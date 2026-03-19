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
          :noise_level, :cleanliness_level, :sleep_schedule,
          :smoking_allowed, :pets_allowed, :parties_allowed,
          :guest_frequency, :lifestyle_tags, :move_in_date, :max_budget
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
          noise_level: profile.noise_level,
          cleanliness_level: profile.cleanliness_level,
          sleep_schedule: profile.sleep_schedule,
          smoking_allowed: profile.smoking_allowed,
          pets_allowed: profile.pets_allowed,
          parties_allowed: profile.parties_allowed,
          guest_frequency: profile.guest_frequency,
          lifestyle_tags: profile.lifestyle_tags,
          move_in_date: profile.move_in_date,
          max_budget: profile.max_budget,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
