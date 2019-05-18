# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  text         :string
#  read_flag    :boolean          default(FALSE)
#  favor_flag   :boolean          default(FALSE)
#  muted        :boolean          default(FALSE)
#  from_user_id :integer
#  from_addr    :string
#  to_note_id   :integer
#  response_id  :integer
#  anonimity    :integer          default("secret")
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Comment < ApplicationRecord
  acts_as_paranoid

  validates :text, presence: true
  validates :to_note, presence: true

  enum anonimity: {
    secret: 0,
    open: 1
  }, _suffix: true

  belongs_to :from_user,
             class_name: 'User',
             foreign_key: 'from_user_id',
             optional: true
  belongs_to :to_note, class_name: 'Note', foreign_key: 'to_note_id'
  belongs_to :response_post,
             class_name: 'Post',
             foreign_key: 'response_id',
             optional: true

  scope :not_muted, ->{
    where(muted: false)
  }
  scope :join_blockdata, ->{
    joins(to_note: { user: :user_blocks } )
  }
  scope :blocked_by_id, ->{
    join_blockdata.merge(UserBlock.blocked_by_id)
                  .where("comments.from_user_id = user_blocks.blocking_user_id")
  }
  scope :blocked_by_addr, ->{
    join_blockdata.merge(UserBlock.blocked_by_addr)
                  .where("comments.from_addr = user_blocks.blocking_addr")
  }
  scope :blocked, ->{
    blocked_by_id.or(blocked_by_addr)
  }
  
end
