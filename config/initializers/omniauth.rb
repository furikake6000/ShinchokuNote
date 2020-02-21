Rails.application.config.middleware.use OmniAuth::Builder do
  #if Rails.env == 'production'
  #  provider :twitter,
  #           Rails.application.credentials.twitter[:key],
  #           Rails.application.credentials.twitter[:secret]
  #else
  #  provider :twitter,
  #           Rails.application.credentials.twitter_dev[:key],
  #           Rails.application.credentials.twitter_dev[:secret]
  #end

  provider :twitter,
    Rails.application.credentials.twitter[:key],
    Rails.application.credentials.twitter[:secret]
end

# リダイレクト用のURIを設定
OmniAuth.config.full_host = ENV['HOST_URI'] if ENV['HOST_URI']
