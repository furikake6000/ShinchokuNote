# == Schema Information
#
# Table name: user_blocks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  to_user_id :integer
#  to_addr    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserBlock < ApplicationRecord
  belongs_to :user
  belongs_to :to_user,
             class_name: 'User',
             foreign_key: 'to_user_id',
             optional: true
  
  # Can not block same user twice, whether id or addr
  validates :user_id, uniqueness: { score: [:to_user_id, :to_addr] }
end
