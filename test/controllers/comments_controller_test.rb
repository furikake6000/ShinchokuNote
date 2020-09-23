require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = create(:user)
    @noritama = create(:user)
    @noriwasa = create(:user)
    @okaka_project1 = create(:project, user: @okaka)
    @noritama_project1 = create(:project, user: @noritama)
    @okaka_comment1 = create(:comment, from_user: @okaka, to_note: @noritama_project1)
    @noritama_comment1 = create(:comment, from_user: @noritama, to_note: @okaka_project1)

    # Noritama follows okaka
    Twitter::REST::Client.any_instance.stubs(:friendship?).with(@noritama.screen_name, @okaka.screen_name).returns(true)
    # Noriwasa doesn't follow okaka
    Twitter::REST::Client.any_instance.stubs(:friendship?).with(@noriwasa.screen_name, @okaka.screen_name).returns(false)
  end

  test 'make new comment(everyone)' do
    # Changing comment_receive_stance
    @okaka_project1.everyone_comment_receive_stance!
    @okaka_project1.save!

    # Comment from anonimous
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of anonimous',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (not follower)
    login_for_test @noriwasa
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_for_test @noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_for_test @okaka
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of myself',
        anonimity: :anonimity_secret
      } }
    end
  end

  test 'make new comment(only_signed)' do
    # Changing comment_receive_stance
    @okaka_project1.only_signed_comment_receive_stance!
    @okaka_project1.save!

    # Comment from anonimous
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of anonimous',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (not follower)
    login_for_test @noriwasa
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_for_test @noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_for_test @okaka
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of myself',
        anonimity: :anonimity_secret
      } }
    end
  end

  test 'make new comment(only_follower)' do
    # Changing comment_receive_stance
    @okaka_project1.only_follower_comment_receive_stance!
    @okaka_project1.save!

    # Comment from anonimous
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of anonimous',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (not follower)
    login_for_test @noriwasa
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_for_test @noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_for_test @okaka
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of myself',
        anonimity: :anonimity_secret
      } }
    end
  end

  test 'make new comment(only_me)' do
    # Changing comment_receive_stance
    @okaka_project1.only_me_comment_receive_stance!
    @okaka_project1.save!

    # Comment from anonimous
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of anonimous',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (not follower)
    login_for_test @noriwasa
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_for_test @noritama
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_for_test @okaka
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of myself',
        anonimity: :anonimity_secret
      } }
    end
  end

  test 'delete comment' do
    login_for_test @okaka

    # deleting a comment
    assert_difference 'Comment.count', -1 do
      delete comment_path(@okaka_comment1)
    end

    # check comment has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Comment.find(@okaka_comment1.id)
    end
    # check comment has deleted logically(paranoid)
    okaka_comment1_tomb = Comment.with_deleted.find(@okaka_comment1.id)
    assert okaka_comment1_tomb
    assert okaka_comment1_tomb.deleted?
  end

  test 'delete comment as admin' do
    admin = create(:user, :admin)
    login_for_test admin

    # deleting a comment
    assert_difference 'Comment.count', -1 do
      delete comment_path(@noritama_comment1)
    end

    # check comment has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Comment.find(@noritama_comment1.id)
    end
    # check comment has deleted logically(paranoid)
    noritama_comment1_tomb = Comment.with_deleted.find(@noritama_comment1.id)
    assert noritama_comment1_tomb
    assert noritama_comment1_tomb.deleted?
  end

  test 'delete comment as others' do
    login_for_test @noritama

    # deleting a comment(failure)
    assert_no_difference 'Comment.count' do
      delete comment_path(@okaka_comment1)
    end

    # check comment has not deleted
    assert Comment.find(@okaka_comment1.id)
  end
end
