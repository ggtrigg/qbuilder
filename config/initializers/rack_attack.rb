# frozen_string_literal: true

# Configure Rack::Attack for rate limiting and security

class Rack::Attack
  # Throttle response submissions by IP + questionnaire
  # Limit: 5 submissions per 5 minutes per IP per questionnaire
  throttle("responses/create", limit: 5, period: 5.minutes) do |req|
    if req.path.match?(%r{/questionnaires/\d+/responses}) && req.post?
      questionnaire_id = req.path[%r{/questionnaires/(\d+)/responses}, 1]
      "#{req.ip}:#{questionnaire_id}"
    end
  end

  # Throttle login attempts
  throttle("logins/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.ip
    end
  end

  # Throttle sign up attempts
  throttle("signups/ip", limit: 3, period: 10.minutes) do |req|
    if req.path == "/users" && req.post?
      req.ip
    end
  end

  # Blocklist for suspicious activity
  blocklist("fail2ban") do |req|
    # Block IPs that exceed limits
    Rack::Attack::Fail2Ban.filter("fail2ban-#{req.ip}", maxretry: 10, findtime: 10.minutes, bantime: 1.hour) do
      # Count failed login attempts
      req.path == "/users/sign_in" && req.post? && req.params.dig("user", "password").blank?
    end
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |env|
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      { "Content-Type" => "application/json", "Retry-After" => retry_after.to_s },
      [{ error: "Too many requests. Please wait before trying again." }.to_json]
    ]
  end

  # Custom response for blocklisted requests
  self.blocklisted_responder = lambda do |env|
    [
      403,
      { "Content-Type" => "application/json" },
      [{ error: "Access denied." }.to_json]
    ]
  end
end

# Disable rack-attack in test environment unless explicitly enabled
Rack::Attack.enabled = !Rails.env.test? || ENV["ENABLE_RACK_ATTACK"] == "true"