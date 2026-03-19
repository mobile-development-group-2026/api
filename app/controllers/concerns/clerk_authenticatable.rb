module ClerkAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_clerk_user!
  end

  private

  def authenticate_clerk_user!
    # Dev bypass: in development, allow X-Dev-Clerk-Id header to skip JWT verification
    if Rails.env.development? && request.headers["X-Dev-Clerk-Id"].present?
      @current_user = User.find_by(clerk_id: request.headers["X-Dev-Clerk-Id"])
      if @current_user.nil?
        render json: { error: "Dev user not found for clerk_id: #{request.headers['X-Dev-Clerk-Id']}" }, status: :unauthorized
      end
      return
    end

    token = extract_bearer_token
    if token.nil?
      render json: { error: "Missing Authorization header" }, status: :unauthorized
      return
    end

    payload = ClerkJwtVerifier.verify(token)
    @current_user = User.find_by!(clerk_id: payload["sub"])
  rescue ClerkJwtVerifier::VerificationError => e
    render json: { error: e.message }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found. Call POST /api/v1/auth/sync first." }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def extract_bearer_token
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")

    header.split(" ").last
  end
end
