require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @noriwasa = users(:noriwasa)
    @okaka_project1 = notes(:okaka_project_1)
    @noritama_project1 = notes(:noritama_project_1)
    # Noritama follows okaka
    # Noriwasa doesn't follow okaka
    @okaka_comment1 = comments(:okaka_to_noritama_comment_1)
    @noritama_comment1 = comments(:noritama_to_okaka_comment_1)
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
    login_as_noriwasa
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_as_noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_as_okaka
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
    login_as_noriwasa
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_as_noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_as_okaka
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
    login_as_noriwasa
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_as_noritama
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_as_okaka
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
    login_as_noriwasa
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment from other user (follower)
    login_as_noritama
    assert_no_difference '@okaka_project1.comments.count' do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of others',
        anonimity: :anonimity_secret
      } }
    end

    # Comment of myself
    login_as_okaka
    assert_difference '@okaka_project1.comments.count', 1 do
      post note_comments_path(@okaka_project1), params: { comment: {
        text: 'Comment of myself',
        anonimity: :anonimity_secret
      } }
    end
  end

  test 'delete comment' do
    login_as_okaka

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
    login_as_okaka

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
    login_as_noritama

    # deleting a comment(failure)
    assert_no_difference 'Comment.count' do
      delete comment_path(@okaka_comment1)
    end

    # check comment has not deleted
    assert Comment.find(@okaka_comment1.id)
  end
end
