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
    @okaka_project1.everyone_comment_receive_stance!
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
    @okaka_project1.everyone_comment_receive_stance!
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
    @okaka_project1.everyone_comment_receive_stance!
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
end
