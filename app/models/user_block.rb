# == Schema Information
#
# Table name: user_blocks
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  blocking_user_id :integer
#  blocking_addr    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserBlock < ApplicationRecord
  belongs_to :user
  belongs_to :blocking_user,
             class_name: 'User',
             foreign_key: 'blocking_user_id',
             optional: true
  
  # Can not block same user twice, whether id or addr
  validates :user_id, uniqueness: { score: [:blocking_user_id, :blocking_addr] }

  scope :blocked_by_addr, -> { where( blocking_user_id: nil ) }
  scope :blocked_by_id, -> { where.not( blocking_user_id: nil ) }
end
