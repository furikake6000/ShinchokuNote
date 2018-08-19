class Note < ApplicationRecord
  acts_as_paranoid

  enum type: {
    RequestBox: 'RequestBox',
    Project: 'Project'
  }
  enum view_stance: {
    only_me: 0,
    only_follower: 1,
    only_signed: 2,
    everyone: 10
  }, _suffix: true
  enum comment_receive_stance: {
    only_me: 0,
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
  enum rating: {
    everyone: 0,
    restricted_18: 1
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
           foreign_key: 'to_note_id',
           dependent: :destroy

  has_many :watching_users,
           through: :watchlists

  has_many :shinchoku_dodeskas,
           class_name: 'ShinchokuDodeska',
           foreign_key: 'to_note_id',
           dependent: :destroy

  validates :name, presence: true
  validates :type, presence: true
  validates_uniqueness_of :name, scope: :user

  def watchlisted_by?(user)
    watching_users.include? user
  end
end
