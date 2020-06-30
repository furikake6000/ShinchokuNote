# == Schema Information
#
# Table name: comments
#
#  id           :bigint(8)        not null, primary key
#  text         :string
#  read_flag    :boolean          default(FALSE)
#  favor_flag   :boolean          default(FALSE)
#  muted        :boolean          default(FALSE)
#  from_user_id :bigint(8)
#  from_addr    :string
#  to_note_id   :bigint(8)
#  response_id  :bigint(8)
#  anonimity    :integer          default("secret")
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
