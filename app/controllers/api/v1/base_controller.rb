module Api
  module V1
    class BaseController < ApplicationController
      include ClerkAuthenticatable

      private

      def authorize_owner!(resource)
        unless resource.user_id == current_user.id
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end

      def authorize_role!(role)
        unless current_user.role == role
          render json: { error: "Forbidden: requires #{role} role" }, status: :forbidden
        end
      end
    end
  end
end
