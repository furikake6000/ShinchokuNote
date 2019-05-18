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

require 'test_helper'

class UserBlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
