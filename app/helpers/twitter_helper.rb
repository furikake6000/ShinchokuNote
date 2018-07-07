module TwitterHelper
  def client_new
    # Twitter APIのセットアップ
    Twitter::REST::Client.new do |config|
      if Rails.env == 'production'
        config.consumer_key = Rails.application.credentials.twitter[:key]
        config.consumer_secret = Rails.application.credentials.twitter[:secret]
      else
        config.consumer_key = Rails.application.credentials.twitter_dev[:key]
        config.consumer_secret = Rails.application.credentials.twitter_dev[:secret]
      end
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
    basetext.gsub!(/#進捗ノート\s/, '')
    # 余分なURLの取り除き
    basetext.gsub!(URI.regexp(%w[http https]), '')
    # 末尾空白文字の取り除き
    basetext.strip!

    basetext
  end
end
