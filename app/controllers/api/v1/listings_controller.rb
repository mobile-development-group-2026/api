module Api
  module V1
    class ListingsController < BaseController
      include ListingSerializer
      skip_before_action :authenticate_clerk_user!, only: [:index, :show, :view]
      before_action :set_listing, only: [:show, :update, :destroy, :mark_rented, :view]

      def index
        listings = Listing.includes(:favorites)
          .then { |q| q.by_type(params[:type]) }
          .then { |q| q.by_city(params[:city]) }
          .then { |q| q.by_status(params[:status] || "active") }
          .then { |q| q.by_bedrooms(params[:bedrooms]) }
          .then { |q| q.min_price(params[:min_price]) }
          .then { |q| q.max_price(params[:max_price]) }
          .order(created_at: :desc)
          .page(params[:page])
          .per(params[:per_page] || 20)

        render json: {
          data: listings.map { |l| listing_json(l) },
          meta: {
            total: listings.total_count,
            page: listings.current_page,
            per_page: listings.limit_value,
            total_pages: listings.total_pages
          }
        }
      end

      def mine
        listings = current_user.listings
          .includes(:favorites)
          .order(created_at: :desc)

        render json: {
          data: listings.map { |l| listing_json(l) }
        }
      end

      def show
        render json: { data: listing_json(@listing, include_photos: true) }
      end

      def create
        listing = current_user.listings.build(listing_params)

        # Enforce role-based listing types
        if current_user.student? && listing.listing_type != "room"
          render json: { error: "Students can only create room listings" }, status: :forbidden
          return
        end

        if current_user.landlord? && listing.listing_type != "property"
          render json: { error: "Landlords can only create property listings" }, status: :forbidden
          return
        end

        listing.save!
        render json: { data: listing_json(listing) }, status: :created
      end

      def update
        authorize_owner!(@listing)
        return if performed?

        @listing.update!(listing_params)
        render json: { data: listing_json(@listing) }
      end

      def destroy
        authorize_owner!(@listing)
        return if performed?

        @listing.destroy!
        render json: { message: "Listing deleted" }
      end

      def view
        # Don't count the owner viewing their own listing
        unless current_user&.id == @listing.user_id
          @listing.increment!(:views_count)
        end
        render json: { data: { views_count: @listing.views_count } }
      end

      def mark_rented
        authorize_owner!(@listing)
        return if performed?

        @listing.update!(status: "rented")
        render json: { data: listing_json(@listing) }
      end

      private

      def set_listing
        @listing = Listing.find(params[:id])
      end

      def listing_params
        params.require(:listing).permit(
          :listing_type, :title, :description, :property_type,
          :address, :city, :state, :zip_code,
          :latitude, :longitude,
          :rent, :security_deposit,
          :utilities_included, :utilities_cost,
          :available_date, :lease_term_months,
          :bedrooms, :bathrooms,
          :pets_allowed, :parties_allowed, :smoking_allowed,
          amenities: [], rules: []
        )
      end

    end
  end
end
