Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.recaptcha[:key]
  config.secret_key = Rails.application.credentials.recaptcha[:secret]
end