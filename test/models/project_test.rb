# == Schema Information
#
# Table name: notes
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  desc                   :string
#  type                   :string
#  stage                  :integer          default("in_progress")
#  thumb_info             :string
#  tags                   :string
#  comment_receive_stance :integer          default("everyone")
#  comment_share_stance   :integer          default("only_me")
#  user_id                :bigint(8)
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
  test 'valid project' do
    assert create(:project).valid?
  end

  test 'invalid project no_name' do
    project = create(:project)
    project.name = ''
    assert_not project.valid?
  end
end
