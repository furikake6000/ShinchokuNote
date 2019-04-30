# == Schema Information
#
# Table name: user_blocks
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  to_addr      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserBlock < ApplicationRecord
end
