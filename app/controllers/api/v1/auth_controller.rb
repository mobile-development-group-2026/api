module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_clerk_user!, only: [:sync]

      def sync
        # In production, the clerk_id comes from the JWT
        # In dev with bypass, it can come from the header
        clerk_id = extract_clerk_id_from_token_or_header

        if clerk_id.nil?
          render json: { error: "No authentication provided" }, status: :unauthorized
          return
        end

        user = User.find_or_initialize_by(clerk_id: clerk_id)
        user.assign_attributes(sync_params) if user.new_record?
        user.last_seen_at = Time.current
        user.save!

        render json: { data: user_json(user) }, status: user.previously_new_record? ? :created : :ok
      end

      private

      def sync_params
        params.fetch(:user, {}).permit(:role, :first_name, :last_name, :email, :phone)
      end

      def extract_clerk_id_from_token_or_header
        # Try JWT first
        token = extract_bearer_token
        if token
          payload = ClerkJwtVerifier.verify(token)
          return payload["sub"]
        end

        # Dev bypass
        if Rails.env.development? && request.headers["X-Dev-Clerk-Id"].present?
          return request.headers["X-Dev-Clerk-Id"]
        end

        nil
      rescue ClerkJwtVerifier::VerificationError
        nil
      end

      def user_json(user)
        {
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
          last_seen_at: user.last_seen_at,
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      end
    end
  end
end
