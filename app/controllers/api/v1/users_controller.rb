module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: { data: public_user_json(user) }
      end

      private

      def public_user_json(user)
        json = {
          id: user.id,
          role: user.role,
          first_name: user.first_name,
          last_name: user.last_name,
          avatar_url: user.avatar_url,
          verified: user.verified,
          created_at: user.created_at
        }

        if user.student? && user.student_profile
          json[:bio] = user.student_profile.bio
          json[:university] = user.student_profile.university
        end

        json
      end
    end
  end
end
