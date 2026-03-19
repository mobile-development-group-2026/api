module Api
  module V1
    class ListingPhotosController < BaseController
      before_action :set_listing

      def create
        authorize_owner!(@listing)
        return if performed?

        photo = @listing.listing_photos.build(photo_params)
        photo.save!
        render json: { data: { id: photo.id, photo_url: photo.photo_url, position: photo.position } }, status: :created
      end

      def destroy
        authorize_owner!(@listing)
        return if performed?

        photo = @listing.listing_photos.find(params[:id])
        photo.destroy!
        render json: { message: "Photo removed" }
      end

      private

      def set_listing
        @listing = Listing.find(params[:listing_id])
      end

      def photo_params
        params.require(:photo).permit(:photo_url, :position)
      end
    end
  end
end
