class Note < ApplicationRecord
  enum type: {
    RequestBox: 'RequestBox',
    Project: 'Project',
    FinishedProject: 'FinishedProject',
    Idea: 'Idea'
  }
  enum comment_receive_stance: {
    noone: 0,
    only_follower: 1,
    only_signed: 2,
    everyone: 10
  }, _suffix: true
  enum comment_share_stance: {
    only_me: 0,
    only_follower: 1,
    only_signed: 2,
    everyone: 10
  }, _suffix: true

  belongs_to :user

  has_many :posts,
           dependent: :destroy

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
  validates_uniqueness_of :name, scope: :user
end
