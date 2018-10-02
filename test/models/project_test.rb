# == Schema Information
#
# Table name: notes
#
#  id                     :integer          not null, primary key
#  name                   :string
#  desc                   :string
#  type                   :string
#  stage                  :integer          default("in_progress")
#  thumb_info             :string
#  tags                   :string
#  comment_receive_stance :integer          default("everyone")
#  comment_share_stance   :integer          default("only_me")
#  user_id                :integer
#  started_at             :datetime
#  finished_at            :datetime
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  view_stance            :integer          default("everyone")
#  shared_to_public       :boolean          default(TRUE)
#  rating                 :integer          default("everyone")
#

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @okaka_project2 = notes(:okaka_project_2)
    @noritama_project1 = notes(:noritama_project_1)
  end

  test 'valid project' do
    assert @okaka_project1.valid?
  end

  test 'invalid project no_name' do
    @okaka_project1.name = ''
    assert_not @okaka_project1.valid?
  end
end
