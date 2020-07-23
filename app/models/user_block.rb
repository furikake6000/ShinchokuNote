# == Schema Information
#
# Table name: user_blocks
#
#  id                  :bigint(8)        not null, primary key
#  user_id             :bigint(8)
#  blocking_user_id    :bigint(8)
#  blocking_addr       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  blocking_comment_id :bigint(8)
#

class UserBlock < ApplicationRecord
  belongs_to :user
  belongs_to :blocking_user,
             class_name: 'User',
             foreign_key: 'blocking_user_id',
             optional: true
  belongs_to :blocking_comment,
             class_name: 'Comment',
             foreign_key: 'blocking_comment_id'
  
  # Can not block same user twice, whether id or addr
  validates :user_id, uniqueness: { scope: [:blocking_user_id, :blocking_addr] }

  scope :blocked_by_addr, -> { where( blocking_user_id: nil ) }
  scope :blocked_by_id, -> { where.not( blocking_user_id: nil ) }
end
