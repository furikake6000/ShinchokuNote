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

  def tweet_url(tweet)
    "https://twitter.com/i/web/status/#{tweet.id}"
  end

  def origin_text(tweet)
    # テキストの取得
    tweet_h = tweet.to_h

    basetext = ''
    if tweet_h[:full_text] && !tweet_h[:full_text].empty?
      basetext = tweet_h[:full_text]
    else
      basetext = tweet.text.dup
    end

    # 余分なハッシュタグの取り除き
    basetext.gsub!(/#進捗ノート/, '')
    # 余分なURLの取り除き
    basetext.gsub!(URI.regexp(%w[http https]), '')

    basetext
  end
end
