# == Schema Information
#
# Table name: shinchoku_dodeskas
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  from_addr    :string
#  to_note_id   :integer
#  content      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ShinchokuDodeskaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
