# == Schema Information
#
# Table name: watchlists
#
#  id           :bigint(8)        not null, primary key
#  from_user_id :bigint(8)
#  to_note_id   :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
