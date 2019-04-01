include CredentialsWrapper

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    credentials_wrap('twitter', 'key'),
    credentials_wrap('twitter', 'secret')
end
