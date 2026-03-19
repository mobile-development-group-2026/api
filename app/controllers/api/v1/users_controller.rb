module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: { data: public_user_json(user) }
      end

      private

      def public_user_json(user)
        {
          id: user.id,
          role: user.role,
          first_name: user.first_name,
          last_name: user.last_name,
          avatar_url: user.avatar_url,
          bio: user.bio,
          university: user.university,
          verified: user.verified,
          created_at: user.created_at
        }
      end
    end
  end
end
