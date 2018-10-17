# == Schema Information
#
# Table name: announces
#
#  id         :integer          not null, primary key
#  text       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AnnounceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
