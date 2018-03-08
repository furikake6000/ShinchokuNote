class TweetPost < Post
  def tweet
    return @data unless @data.nil?
    data_hash = JSON.parse text, symbolize_names: true
    @data = Twitter::Tweet.new(data_hash)
  end
end
