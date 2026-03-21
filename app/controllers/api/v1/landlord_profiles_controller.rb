module Api
  module V1
    class LandlordProfilesController < BaseController
      before_action :ensure_landlord!

      def show
        profile = current_user.landlord_profile || current_user.create_landlord_profile!
        render json: { data: profile_json(profile) }
      end

      def update
        profile = current_user.landlord_profile || current_user.create_landlord_profile!
        profile.update!(profile_params)
        render json: { data: profile_json(profile) }
      end

      private

      def ensure_landlord!
        authorize_role!("landlord")
      end

      def profile_params
        params.require(:landlord_profile).permit(
          :birth_year, :bio, hobbies: []
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
          birth_year: profile.birth_year,
          bio: profile.bio,
          hobbies: profile.hobbies,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
