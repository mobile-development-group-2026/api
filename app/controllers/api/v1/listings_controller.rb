module Api
  module V1
    class ListingsController < BaseController
      skip_before_action :authenticate_clerk_user!, only: [:index, :show]
      before_action :set_listing, only: [:show, :update, :destroy, :mark_rented]

      def index
        listings = Listing.all
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

      def listing_json(listing, include_photos: false)
        json = {
          id: listing.id,
          user_id: listing.user_id,
          listing_type: listing.listing_type,
          title: listing.title,
          description: listing.description,
          property_type: listing.property_type,
          address: listing.address,
          city: listing.city,
          state: listing.state,
          zip_code: listing.zip_code,
          latitude: listing.latitude,
          longitude: listing.longitude,
          rent: listing.rent,
          security_deposit: listing.security_deposit,
          utilities_included: listing.utilities_included,
          utilities_cost: listing.utilities_cost,
          available_date: listing.available_date,
          lease_term_months: listing.lease_term_months,
          bedrooms: listing.bedrooms,
          bathrooms: listing.bathrooms,
          pets_allowed: listing.pets_allowed,
          parties_allowed: listing.parties_allowed,
          smoking_allowed: listing.smoking_allowed,
          amenities: listing.amenities,
          rules: listing.rules,
          status: listing.status,
          created_at: listing.created_at,
          updated_at: listing.updated_at
        }

        if include_photos
          json[:photos] = listing.listing_photos.order(:position).map do |photo|
            { id: photo.id, photo_url: photo.photo_url, position: photo.position }
          end
        end

        json
      end
    end
  end
end
