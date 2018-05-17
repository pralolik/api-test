class JsonWebToken
  class << self
    def encode (playload, exp = 24.hours.from_now)
      playload[:exp] = exp.to_i
      JWT.encode(playload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end