module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: { data: user_json(current_user) }
      end

      def update
        current_user.update!(profile_params)
        render json: { data: user_json(current_user) }
      end

      private

      def profile_params
        params.require(:user).permit(:first_name, :last_name, :phone, :avatar_url, :onboarded)
      end

      def user_json(user)
        json = {
          id: user.id,
          clerk_id: user.clerk_id,
          role: user.role,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          phone: user.phone,
          avatar_url: user.avatar_url,
          verified: user.verified,
          onboarded: user.onboarded,
          created_at: user.created_at,
          updated_at: user.updated_at
        }

        if user.student? && user.student_profile
          json[:student_profile] = student_profile_json(user.student_profile)
        end

        if user.lifestyle_profile
          json[:lifestyle_profile] = lifestyle_profile_json(user.lifestyle_profile)
        end

        json
      end

      def student_profile_json(profile)
        {
          id: profile.id,
          university: profile.university,
          major: profile.major,
          birth_year: profile.birth_year,
          graduation_year: profile.graduation_year,
          bio: profile.bio,
          hobbies: profile.hobbies
        }
      end

      def lifestyle_profile_json(profile)
        {
          id: profile.id,
          noise_level: profile.noise_level,
          cleanliness_level: profile.cleanliness_level,
          sleep_schedule: profile.sleep_schedule,
          smoking_allowed: profile.smoking_allowed,
          pets_allowed: profile.pets_allowed,
          parties_allowed: profile.parties_allowed,
          guest_frequency: profile.guest_frequency,
          lifestyle_tags: profile.lifestyle_tags,
          move_in_date: profile.move_in_date,
          max_budget: profile.max_budget
        }
      end
    end
  end
end
