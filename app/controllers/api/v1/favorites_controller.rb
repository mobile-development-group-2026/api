module Api
  module V1
    class FavoritesController < BaseController
      include ListingSerializer

      # GET /api/v1/favorites — current user's favorited listings
      def index
        listings = current_user.favorited_listings
          .includes(:favorites)
          .order("favorites.created_at DESC")

        render json: { data: listings.map { |l| listing_json(l) } }
      end

      # POST /api/v1/listings/:listing_id/favorite
      def create
        listing = Listing.find(params[:listing_id])
        favorite = current_user.favorites.find_or_initialize_by(listing: listing)

        if favorite.new_record?
          favorite.save!
          listing.favorites.reload
        end

        render json: {
          data: { favorited: true, favorites_count: listing.favorites.size }
        }, status: :ok
      end

      # DELETE /api/v1/listings/:listing_id/favorite
      def destroy
        listing = Listing.find(params[:listing_id])
        current_user.favorites.find_by(listing: listing)&.destroy!
        listing.favorites.reload

        render json: {
          data: { favorited: false, favorites_count: listing.favorites.size }
        }
      end
    end
  end
end
