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
          :university, :major, :age, :birth_year, :graduation_year, :bio
        )
      end

      def profile_json(profile)
        {
          id: profile.id,
          user_id: profile.user_id,
          university: profile.university,
          major: profile.major,
          age: profile.age,
          birth_year: profile.birth_year,
          graduation_year: profile.graduation_year,
          bio: profile.bio,
          created_at: profile.created_at,
          updated_at: profile.updated_at
        }
      end
    end
  end
end
