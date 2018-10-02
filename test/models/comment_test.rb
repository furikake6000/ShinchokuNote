# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  text         :string
#  read_flag    :boolean          default(FALSE)
#  favor_flag   :boolean          default(FALSE)
#  muted        :boolean          default(FALSE)
#  from_user_id :integer
#  from_addr    :string
#  to_note_id   :integer
#  response_id  :integer
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
