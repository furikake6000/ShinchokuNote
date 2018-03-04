class Note < ApplicationRecord
  belongs_to :user

  has_many :posts

  has_many :comments,
           class_name: 'Comment',
           foreign_key: 'to_note_id',
           dependent: :destroy

  has_many :watchlists,
           class_name: 'Watchlist',
           foreign_key: 'from_user_id',
           dependent: :destroy

  has_many :watching_users,
           through: :watchlists

  validates :name, presence: true
  validates :type, presence: true
end
