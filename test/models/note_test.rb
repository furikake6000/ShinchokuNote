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

  test '投稿すると更新日が更新される' do
    today = Time.current
    yesterday = today.yesterday

    note = nil
    Timecop.freeze(yesterday) do
      note = create(:project)
    end
    assert_equal note.updated_at, yesterday

    post = nil
    Timecop.freeze(today) do
      post = create(:post, note: note)
    end
    assert_equal note.updated_at, today
  end

  test 'user.noteが作成日降順に並ぶ' do
    user = create(:user)
    current_note = create(:project, user: user)
    old_note, new_note = nil
    Timecop.freeze(Time.current.yesterday) do
      old_note = create(:project, user: user)
    end
    Timecop.freeze(Time.current.tomorrow) do
      new_note = create(:project, user: user)
    end

    assert_equal user.notes.first.id, new_note.id
    assert_equal user.notes.second.id, current_note.id
    assert_equal user.notes.third.id, old_note.id
  end

  test 'user.noteが更新日降順に並ぶ' do
    user = create(:user)
    old_note, older_note = nil
    Timecop.freeze(Time.current.yesterday) do
      old_note = create(:project, user: user)
    end
    Timecop.freeze(Time.current.ago(2.days)) do
      older_note = create(:project, user: user)
    end

    assert_equal user.notes.first.id, old_note.id
    assert_equal user.notes.second.id, older_note.id

    # 新規投稿をすると順番が入れ替わる

    create(:post, note: older_note)

    assert_equal user.notes.first.id, older_note.id
    assert_equal user.notes.second.id, old_note.id

    create(:post, note: old_note)

    assert_equal user.notes.first.id, old_note.id
    assert_equal user.notes.second.id, older_note.id
  end
end
