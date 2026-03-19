require "jwt"
require "net/http"
require "json"

class ClerkJwtVerifier
  class VerificationError < StandardError; end

  JWKS_CACHE_KEY = "clerk_jwks_keys"
  JWKS_CACHE_TTL = 1.hour

  class << self
    def verify(token)
      payload, _header = JWT.decode(
        token,
        nil,
        true,
        {
          algorithms: ["RS256"],
          jwks: jwks
        }
      )
      payload
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidIssuerError => e
      raise VerificationError, "Invalid token: #{e.message}"
    end

    private

    def jwks
      cached = Rails.cache.read(JWKS_CACHE_KEY)
      return cached if cached

      keys = fetch_jwks
      Rails.cache.write(JWKS_CACHE_KEY, keys, expires_in: JWKS_CACHE_TTL)
      keys
    end

    def fetch_jwks
      clerk_domain = ENV.fetch("CLERK_DOMAIN", "evolving-gelding-61.clerk.accounts.dev")
      uri = URI("https://#{clerk_domain}/.well-known/jwks.json")
      response = Net::HTTP.get(uri)
      JWT::JWK::Set.new(JSON.parse(response))
    rescue StandardError => e
      raise VerificationError, "Failed to fetch JWKS: #{e.message}"
    end
  end
end
