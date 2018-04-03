class Post < ApplicationRecord
  acts_as_paranoid

  enum type: {
    TweetPost: 'TweetPost'
  }

  belongs_to :note
  has_one :responded_comment,
          class_name: 'Comment',
          foreign_key: 'response_id',
          dependent: :nullify

  validates :type, presence: true
end
