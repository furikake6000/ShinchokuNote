class TweetPost < Post
  acts_as_paranoid

  def tweet
    return @data unless @data.nil?
    data_hash = JSON.parse text, symbolize_names: true
    @data = Twitter::Tweet.new(data_hash)
  end

  def sort_condition_date
    created_at
  end
end
