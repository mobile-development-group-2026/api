module Api
  module V1
    class AnalyticsController < BaseController
      skip_before_action :authenticate_clerk_user!,
        only: [:onboarding_funnel, :favorites_funnel, :application_approval, :conversion_matrix]

      # BQ1 — Onboarding completion rate segmented by role
      def onboarding_funnel
        by_role = User.group(:role)
          .select("role, COUNT(*) AS registered, SUM(CASE WHEN onboarded THEN 1 ELSE 0 END) AS completed")
          .map do |r|
            reg  = r.registered.to_i
            comp = r.completed.to_i
            {
              role: r.role,
              registered: reg,
              completedOnboarding: comp,
              completionRate: reg > 0 ? (comp.to_f / reg * 100).round(1) : 0.0
            }
          end

        totals_registered = by_role.sum { |r| r[:registered] }
        totals_completed  = by_role.sum { |r| r[:completedOnboarding] }

        monthly_rows = ActiveRecord::Base.connection.execute(<<~SQL).to_a
          SELECT
            TO_CHAR(DATE_TRUNC('month', created_at), 'Mon') AS month,
            DATE_TRUNC('month', created_at)                 AS month_date,
            COUNT(*)                                        AS registered,
            SUM(CASE WHEN onboarded THEN 1 ELSE 0 END)     AS onboarded
          FROM users
          WHERE created_at >= NOW() - INTERVAL '6 months'
          GROUP BY month_date, month
          ORDER BY month_date
        SQL

        render json: {
          totals:       { registered: totals_registered, completedOnboarding: totals_completed },
          byRole:       by_role,
          monthlyTrend: monthly_rows.map { |r|
            { month: r["month"], registered: r["registered"].to_i, onboarded: r["onboarded"].to_i }
          }
        }
      end

      # BQ2 — % of students who favorited a listing and then applied for it
      def favorites_funnel
        students_who_favorited = Favorite.distinct.count(:user_id)
        total_favorites        = Favorite.count
        total_applications     = Application.count

        students_who_applied = Application
          .joins("INNER JOIN favorites ON favorites.listing_id = applications.listing_id
                                      AND favorites.user_id    = applications.student_id")
          .distinct.count(:student_id)

        conversion_rate = students_who_favorited > 0 ?
          (students_who_applied.to_f / students_who_favorited * 100).round(1) : 0.0

        monthly_fav = ActiveRecord::Base.connection.execute(<<~SQL).to_a
          SELECT TO_CHAR(DATE_TRUNC('month', created_at), 'Mon') AS month,
                 DATE_TRUNC('month', created_at)                 AS month_date,
                 COUNT(DISTINCT user_id)                         AS favorited
          FROM favorites
          WHERE created_at >= NOW() - INTERVAL '6 months'
          GROUP BY month_date, month ORDER BY month_date
        SQL

        monthly_app = ActiveRecord::Base.connection.execute(<<~SQL).to_a
          SELECT TO_CHAR(DATE_TRUNC('month', a.created_at), 'Mon') AS month,
                 DATE_TRUNC('month', a.created_at)                 AS month_date,
                 COUNT(DISTINCT a.student_id)                      AS applied
          FROM applications a
          INNER JOIN favorites f ON f.listing_id = a.listing_id AND f.user_id = a.student_id
          WHERE a.created_at >= NOW() - INTERVAL '6 months'
          GROUP BY month_date, month ORDER BY month_date
        SQL

        app_by_month = monthly_app.index_by { |r| r["month"] }

        monthly = monthly_fav.map do |r|
          applied = app_by_month.dig(r["month"], "applied").to_i
          { month: r["month"], favorited: r["favorited"].to_i, applied: applied }
        end

        bucket_order = ["Same day", "1-3 days", "4-7 days", "8-14 days", "15+ days"]
        tta_rows = ActiveRecord::Base.connection.execute(<<~SQL).index_by { |r| r["bucket"] }
          SELECT
            CASE
              WHEN EXTRACT(EPOCH FROM (a.created_at - f.created_at)) / 86400 < 1  THEN 'Same day'
              WHEN EXTRACT(EPOCH FROM (a.created_at - f.created_at)) / 86400 <= 3 THEN '1-3 days'
              WHEN EXTRACT(EPOCH FROM (a.created_at - f.created_at)) / 86400 <= 7 THEN '4-7 days'
              WHEN EXTRACT(EPOCH FROM (a.created_at - f.created_at)) / 86400 <= 14 THEN '8-14 days'
              ELSE '15+ days'
            END AS bucket,
            COUNT(DISTINCT a.student_id) AS students
          FROM applications a
          INNER JOIN favorites f ON f.listing_id = a.listing_id AND f.user_id = a.student_id
          WHERE a.created_at >= f.created_at
          GROUP BY bucket
        SQL

        render json: {
          summary: {
            studentsWhoFavorited: students_who_favorited,
            studentsWhoApplied:   students_who_applied,
            conversionRate:       conversion_rate,
            totalFavorites:       total_favorites,
            totalApplications:    total_applications
          },
          monthly:       monthly,
          byTimeToApply: bucket_order.map { |b|
            { bucket: b, students: tta_rows.dig(b, "students").to_i }
          }
        }
      end

      # BQ3 — Approval rate per listing; does preferred_visit_at increase approval?
      def application_approval
        total    = Application.count
        approved = Application.where(status: "approved").count
        pending  = Application.where(status: "pending").count
        rejected = Application.where(status: "denied").count

        with_visit    = Application.where.not(preferred_visit_at: nil)
        without_visit = Application.where(preferred_visit_at: nil)

        wc  = with_visit.count;    wa = with_visit.where(status: "approved").count
        woc = without_visit.count; woa = without_visit.where(status: "approved").count

        by_listing = Application
          .joins(:listing)
          .group("applications.listing_id, listings.title")
          .select("applications.listing_id,
                   listings.title,
                   COUNT(*)                                                    AS app_count,
                   SUM(CASE WHEN applications.status = 'approved' THEN 1 ELSE 0 END) AS approved_count")
          .order("app_count DESC")
          .limit(10)
          .map do |r|
            c = r.app_count.to_i; a = r.approved_count.to_i
            { listingId: r.listing_id, title: r.title, applications: c, approved: a,
              approvalRate: c > 0 ? (a.to_f / c * 100).round(1) : 0.0 }
          end

        render json: {
          summary: {
            totalApplications: total,
            approved:          approved,
            pending:           pending,
            rejected:          rejected,
            approvalRate:      total > 0 ? (approved.to_f / total * 100).round(1) : 0.0
          },
          withVsWithoutVisitAt: [
            { category: "With preferred_visit_at",    applications: wc,  approved: wa,
              approvalRate: wc  > 0 ? (wa.to_f  / wc  * 100).round(1) : 0.0 },
            { category: "Without preferred_visit_at", applications: woc, approved: woa,
              approvalRate: woc > 0 ? (woa.to_f / woc * 100).round(1) : 0.0 }
          ],
          byListing: by_listing
        }
      end

      # BQ4 — Favorites-to-application conversion by price range × property type
      def conversion_matrix
        price_ranges = ["< $800k", "$800k - $1.2M", "$1.2M - $1.8M", "$1.8M - $2.5M", "> $2.5M"]

        rows = ActiveRecord::Base.connection.execute(<<~SQL).to_a
          SELECT
            COALESCE(l.property_type, 'unknown') AS property_type,
            CASE
              WHEN l.rent < 800000  THEN '< $800k'
              WHEN l.rent < 1200000 THEN '$800k - $1.2M'
              WHEN l.rent < 1800000 THEN '$1.2M - $1.8M'
              WHEN l.rent < 2500000 THEN '$1.8M - $2.5M'
              ELSE '> $2.5M'
            END AS price_range,
            COUNT(DISTINCT f.id)::int AS favorites,
            COUNT(DISTINCT a.id)::int AS applications
          FROM listings l
          LEFT JOIN favorites    f ON f.listing_id = l.id
          LEFT JOIN applications a ON a.listing_id = l.id
          GROUP BY l.property_type, price_range
          ORDER BY l.property_type, price_range
        SQL

        property_types = rows.map { |r| r["property_type"] }.uniq.compact.sort

        render json: {
          priceRanges:   price_ranges,
          propertyTypes: property_types,
          matrix: rows.map { |r|
            favs = r["favorites"].to_i; apps = r["applications"].to_i
            { propertyType:   r["property_type"],
              priceRange:     r["price_range"],
              favorites:      favs,
              applications:   apps,
              conversionRate: favs > 0 ? (apps.to_f / favs * 100).round(1) : 0.0 }
          }
        }
      end

      def index
        sector_counts = ProximityEvent.group(:sector).count
        
        sectors_data = sector_counts.map do |name, count|
          { sector: name, visits: count }
        end

        total_visits = sector_counts.values.sum

        render json: {
          sector_analytics: sectors_data.map do |s|
            {
              id: s[:sector],
              sector: s[:sector],
              interest_level: interest_level(s[:visits]),
              unique_visitors: s[:visits], 
              visit_count: s[:visits],
              average_daily_traffic: calculate_daily_average(s[:visits])
            }
          end,
          hourly_peaks: [],
          daily_peaks: [],
          total_visits: total_visits,
          unique_sectors: sectors_data.size,
          last_synced_at: ProximityEvent.maximum(:updated_at)
        }
      end

      private

      def interest_level(count)
        return "Low" if count <= 2
        return "Medium" if count <= 9
        "High"
      end

      def calculate_daily_average(count)
        first_event = ProximityEvent.minimum(:event_day)
        return count.to_f if first_event.nil?
        
        days = (Date.current - first_event).to_i + 1
        (count.to_f / days).round(2)
      end
    end
  end
end