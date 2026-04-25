module Api
  module V1
    class AnalyticsController < BaseController
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