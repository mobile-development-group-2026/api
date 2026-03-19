module Api
  module V1
    class StudentProfilesController < BaseController
      before_action :ensure_student!

      def show
        profile = current_user.student_profile || current_user.create_student_profile!
        render json: { data: profile_json(profile) }
      end

      def update
        profile = current_user.student_profile || current_user.create_student_profile!
        profile.update!(profile_params)
        render json: { data: profile_json(profile) }
      end

      private

      def ensure_student!
        authorize_role!("student")
      end

      def profile_params
        params.require(:student_profile).permit(
          :date_of_birth, :gender, :academic_level,
          :budget_min, :budget_max, :move_in_date,
          :noise_level, :cleanliness, :guests_policy,
          :daily_routine, :pets_ok, :smoking_ok
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
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
          smoking_ok: profile.smoking_ok,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
