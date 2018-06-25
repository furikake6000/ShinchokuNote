class Post < ApplicationRecord
  acts_as_paranoid

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
