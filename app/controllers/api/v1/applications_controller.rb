module Api
  module V1
    class ApplicationsController < BaseController
      before_action :set_listing, only: [ :index, :create ]
      before_action :set_application, only: [ :update ]

      # GET /api/v1/listings/:listing_id/applications
      # Landlord views all applications for one of their listings
      def index
        authorize_owner!(@listing)
        return if performed?

        applications = @listing.applications.includes(:student).order(created_at: :desc)
        render json: { data: applications.map { |a| application_json(a) } }
      end

      # POST /api/v1/listings/:listing_id/applications
      # Student applies for a listing
      def create
        authorize_role!("student")
        return if performed?

        application = @listing.applications.build(application_params)
        application.student = current_user
        application.save!
        render json: { data: application_json(application) }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # GET /api/v1/applications/mine
      # Student: their own applications. Landlord: all received applications.
      def mine
        applications = if current_user.student?
          current_user.student_applications.includes(:listing).order(created_at: :desc)
        else
          Application.for_landlord(current_user).includes(:listing, :student).order(created_at: :desc)
        end

        render json: { data: applications.map { |a| application_json(a) } }
      end

      # PATCH /api/v1/applications/:id
      # Landlord approves or denies with optional notes
      def update
        authorize_owner!(@application.listing)
        return if performed?

        new_status = params.dig(:application, :status)
        attrs = update_params
        attrs[:reviewed_at] = Time.current if new_status.in?(%w[approved denied])

        @application.update!(attrs)
        render json: { data: application_json(@application) }
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def set_listing
        @listing = Listing.find(params[:listing_id])
      end

      def set_application
        @application = Application.find(params[:id])
      end

      def application_params
        params.require(:application).permit(:preferred_visit_at, :student_notes)
      end

      def update_params
        params.require(:application).permit(:status, :landlord_notes)
      end

      def application_json(app)
        base = {
          id: app.id,
          listing_id: app.listing_id,
          student_id: app.student_id,
          status: app.status,
          preferred_visit_at: app.preferred_visit_at,
          student_notes: app.student_notes,
          landlord_notes: app.landlord_notes,
          reviewed_at: app.reviewed_at,
          created_at: app.created_at,
          updated_at: app.updated_at
        }

        if app.association(:listing).loaded?
          base[:listing] = { id: app.listing.id, title: app.listing.title }
        end

        if app.association(:student).loaded?
          base[:student] = {
            id: app.student.id,
            first_name: app.student.first_name,
            last_name: app.student.last_name,
            email: app.student.email,
            verified: app.student.verified
          }
        end

        base
      end
    end
  end
end
