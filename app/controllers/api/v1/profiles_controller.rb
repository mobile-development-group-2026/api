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
        params.require(:user).permit(:first_name, :last_name, :phone, :avatar_url, :bio, :university)
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
          bio: user.bio,
          university: user.university,
          verified: user.verified,
          created_at: user.created_at,
          updated_at: user.updated_at
        }

        if user.student? && user.student_profile
          json[:student_profile] = student_profile_json(user.student_profile)
        end

        json
      end

      def student_profile_json(profile)
        {
          id: profile.id,
          date_of_birth: profile.date_of_birth,
          gender: profile.gender,
          academic_level: profile.academic_level,
          budget_min: profile.budget_min,
          budget_max: profile.budget_max,
          move_in_date: profile.move_in_date,
          noise_level: profile.noise_level,
          cleanliness: profile.cleanliness,
          guests_policy: profile.guests_policy,
          daily_routine: profile.daily_routine,
          pets_ok: profile.pets_ok,
          smoking_ok: profile.smoking_ok
        }
      end
    end
  end
end
