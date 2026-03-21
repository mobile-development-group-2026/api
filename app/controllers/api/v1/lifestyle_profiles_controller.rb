module Api
  module V1
    class LifestyleProfilesController < BaseController
      def show
        profile = current_user.lifestyle_profile || current_user.create_lifestyle_profile!
        render json: { data: profile_json(profile) }
      end

      def update
        profile = current_user.lifestyle_profile || current_user.create_lifestyle_profile!
        profile.update!(profile_params)
        render json: { data: profile_json(profile) }
      end

      private

      def profile_params
        params.require(:lifestyle_profile).permit(
          :spots_available, :move_in_month, :gender_preference,
          :sleep_schedule, :cleanliness_level,
          lifestyle: [], requirements: []
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
          spots_available: profile.spots_available,
          move_in_month: profile.move_in_month,
          gender_preference: profile.gender_preference,
          sleep_schedule: profile.sleep_schedule,
          cleanliness_level: profile.cleanliness_level,
          lifestyle: profile.lifestyle,
          requirements: profile.requirements,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
