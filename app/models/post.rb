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

class Post < ApplicationRecord
  acts_as_paranoid

  has_many_attached :media

  enum type: {
    TweetPost: 'TweetPost',
    Schedule: 'Schedule',
    PlainPost: 'PlainPost'
  }

  belongs_to :note, touch: true
  has_one :responded_comment,
          class_name: 'Comment',
          foreign_key: 'response_id',
          dependent: :nullify

  validates :type, presence: true

  def sort_condition_date
    created_at
  end
end
