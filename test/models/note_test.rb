# == Schema Information
#
# Table name: notes
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  desc                   :string
#  type                   :string
#  stage                  :integer          default(2)
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
  test 'invalid note uniqueness' do
    user = create(:user)
    project = create(:project, user: user)
    # Same user cant have same name note
    same_name_project = build(:project, user: user, name: project.name)
    assert_not same_name_project.valid?
    # Other user can have same name note
    same_name_other_user_project = build(:project, name: project.name)
    assert same_name_other_user_project.valid?
  end

  test 'invalid note no_type' do
    # Type "" means plain note, but it isn't allowed.
    project = build(:project)
    project.type = ''
    assert_not project.valid?
  end

  test 'invalid note wrong_type' do
    # Setting wrong type raises ArgumentError.
    project = build(:project)
    assert_raises(ArgumentError) do
      project.type = 'Undefined'
    end
  end
end
