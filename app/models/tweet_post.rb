# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  text         :string
#  type         :string
#  order        :float
#  note_id      :bigint(8)
#  deleted_at   :datetime
#  twitter_id   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  scheduled_at :datetime
#  status       :integer
#  finished_at  :datetime
#

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
