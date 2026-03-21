module Api
  module V1
    class ListingProfilesController < BaseController
      def show
        profile = current_user.listing_profile || current_user.create_listing_profile!
        render json: { data: profile_json(profile) }
      end

      def update
        profile = current_user.listing_profile || current_user.create_listing_profile!
        profile.update!(profile_params)
        render json: { data: profile_json(profile) }
      end

      private

      def profile_params
        params.require(:listing_profile).permit(
          :max_budget, :property_type, :move_in_date,
          :lease_length_months, :max_distance,
          amenities: [], preferences: []
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
          max_budget: profile.max_budget,
          property_type: profile.property_type,
          move_in_date: profile.move_in_date,
          lease_length_months: profile.lease_length_months,
          max_distance: profile.max_distance,
          amenities: profile.amenities,
          preferences: profile.preferences,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
