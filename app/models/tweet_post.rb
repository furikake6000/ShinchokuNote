class TweetPost < Post
  def data
    @data ||= JSON.parse text, symbolize_names: true
  end
end
