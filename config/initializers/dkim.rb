unless Rails.env.test?
  Dkim.domain      = "glenntrigg.net"
  Dkim.selector    = "default"
  Dkim.private_key = Rails.application.credentials.dig(:dkim, :private_key)

  # This will sign all ActionMailer deliveries
  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end
