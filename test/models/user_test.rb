# == Schema Information
#
# Table name: users
#
#  id                                :bigint(8)        not null, primary key
#  twitter_id                        :string
#  name                              :string
#  screen_name                       :string
#  url                               :string
#  thumb_url                         :string
#  desc                              :string
#  user_group_info                   :string
#  permission                        :string           default("")
#  deleted_at                        :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  checked_notifications_at          :datetime
#  linked_users_info                 :binary
#  saw_notifications_at              :datetime
#  comment_webpush_enabled           :boolean          default(TRUE)
#  shinchoku_dodeska_webpush_enabled :boolean          default(TRUE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @okaka = create(:user, :admin)
    @okaka_project = create(:project, user: @okaka)
    @okaka_post = create(:post, note: @okaka_project)
    @okaka_schedule = create(:schedule, note: @okaka_project)
    
    @noritama = create(:user)
    @noritama_project = create(:project, user: @noritama)

    @from_okaka_comment = create(:comment, from_user: @okaka, to_note: @noritama_project)
    @to_okaka_comment = create(:comment, from_user: @noritama, to_note: @okaka_project)
  end

  test 'valid user' do
    assert @okaka.valid?
  end

  test 'invalid user uniqueness' do
    dup_user = @okaka.dup
    @okaka.save
    assert_not dup_user.valid?
  end

  test 'invalid user no_twitter_id' do
    @okaka.twitter_id = nil
    assert_not @okaka.valid?
  end

  test 'admin and nonadmin' do
    assert @okaka.admin?
    assert_not @noritama.admin?
  end

  test 'delete and restore user' do
    assert_not @okaka.deleted?
    assert_not @okaka_project.deleted?
    assert_not @okaka_post.deleted?
    assert_not @okaka_schedule.deleted?
    assert_not @from_okaka_comment.deleted?
    assert_not @to_okaka_comment.deleted?

    assert User.find_by(screen_name: @okaka.screen_name)
    assert Project.find(@okaka_project.id)
    assert Post.find(@okaka_post.id)
    assert Post.find(@okaka_schedule.id)
    assert Comment.find(@from_okaka_comment.id)
    assert Comment.find(@to_okaka_comment.id)

    @okaka.destroy

    assert_nil User.find_by(screen_name: @okaka.screen_name)
    assert_raises(ActiveRecord::RecordNotFound) { Project.find(@okaka_project.id) }
    assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_post.id) }
    assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_schedule.id) }
    assert_raises(ActiveRecord::RecordNotFound) { Comment.find(@from_okaka_comment.id) }
    assert_raises(ActiveRecord::RecordNotFound) { Comment.find(@to_okaka_comment.id) }

    @okaka.restore(recursive: true)

    assert User.find_by(screen_name: @okaka.screen_name)
    assert Project.find(@okaka_project.id)
    assert Post.find(@okaka_post.id)
    assert Post.find(@okaka_schedule.id)
    assert Comment.find(@from_okaka_comment.id)
    assert Comment.find(@to_okaka_comment.id)
  end

  ## This test raises error because of the specification of paranoia gem

  # test 'delete and restore user(deleted note)' do
   
  #   @okaka_project1.destroy

  #   assert_raises(ActiveRecord::RecordNotFound) { Project.find(@okaka_project1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_tweetpost1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_post1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_schedule1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Comment.find(@to_okaka_comment1.id) }

  #   @okaka.destroy

  #   assert_raises(ActiveRecord::RecordNotFound) { Project.find(@okaka_project1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_tweetpost1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_post1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_schedule1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Comment.find(@to_okaka_comment1.id) }

  #   @okaka.restore(recursive: true)

  #   assert_raises(ActiveRecord::RecordNotFound) { Project.find(@okaka_project1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_tweetpost1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_post1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Post.find(@okaka_schedule1.id) }
  #   assert_raises(ActiveRecord::RecordNotFound) { Comment.find(@to_okaka_comment1.id) }
  # end
end
