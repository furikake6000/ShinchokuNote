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

require 'test_helper'

class UserBlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
