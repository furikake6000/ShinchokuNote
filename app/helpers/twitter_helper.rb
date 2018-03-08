module TwitterHelper
  def client_new
    # Twitter APIのセットアップ
    Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_api_key
      config.consumer_secret = Rails.application.secrets.twitter_api_secret
      config.access_token = current_user_token
      config.access_token_secret = current_user_secret
    end
  end
end
