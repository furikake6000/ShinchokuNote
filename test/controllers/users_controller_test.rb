require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
  end

  test 'log in' do
    # Not logged in at first
    assert_not logged_in?
    assert_nil current_user

    # logging in
    login_user @noritama, 'noritama_token', 'noritama_secret'
    assert logged_in?
    assert_equal current_user, @noritama

    # logging out
    logout_user @noritama
    assert_nil current_user
    assert_not logged_in?
  end

  test 'log in as admin' do
    # Admin? is false in at first
    assert_not admin?

    # logging in not as admin
    login_user @noritama, 'noritama_token', 'noritama_secret'
    assert_not admin?
    logout_user @noritama

    # logging in as admin
    login_user @okaka, 'okaka_token', 'okaka_secret'
    assert admin?
    logout_user @okaka

    # logging out
    assert_not admin?
  end

  test 'log in with two accounts' do
    # no master user and current uer at first
    assert_nil master_user
    assert_nil current_user

    # logging in with an account
    login_user @noritama, 'noritama_token', 'noritama_secret'
    assert_equal master_user, @noritama
    assert_equal current_user, @noritama

    # logging in with second account
    login_user @okaka, 'okaka_token', 'okaka_secret'
    assert_equal master_user, @noritama
    assert_equal current_user, @okaka

    # logging out with second account
    logout_user @okaka
    assert_equal master_user, @noritama
    assert_equal current_user, @noritama

    # logging in with second account again
    login_user @okaka, 'okaka_token', 'okaka_secret'
    # logging out with first account
    logout_user @noritama
    assert_nil master_user
    assert_nil current_user
  end

  test 'get user index' do
    # Cant get index without logging in
    get users_path
    assert_redirected_to root_path
    # Cant get index with logging in not as admin
    login_user @noritama, 'noritama_token', 'noritama_secret'
    get users_path
    assert_redirected_to root_path
    # Get index with logging in as admin
    login_user @okaka, 'okaka_token', 'okaka_secret'
    get users_path
    assert_response :success
  end

  test 'get master_user_token and secret' do
    # No token and secret without logging in
    assert_nil master_user_token
    assert_nil master_user_secret
    # Token and secret with logging in
    login_user @noritama, 'noritama_token', 'noritama_secret'
    assert_equal master_user_token, 'noritama_token'
    assert_equal master_user_secret, 'noritama_secret'
    # Token and secret with logging in with two accounts
    login_user @okaka, 'okaka_token', 'okaka_secret'
    assert_equal master_user_token, 'noritama_token'
    assert_equal master_user_secret, 'noritama_secret'
  end

  test 'get current_user_token and secret' do
    # No token and secret without logging in
    assert_nil current_user_token
    assert_nil current_user_secret
    # Token and secret with logging in
    login_user @noritama, 'noritama_token', 'noritama_secret'
    assert_equal current_user_token, 'noritama_token'
    assert_equal current_user_secret, 'noritama_secret'
    # Token and secret with logging in with two accounts
    login_user @okaka, 'okaka_token', 'okaka_secret'
    assert_equal current_user_token, 'okaka_token'
    assert_equal current_user_secret, 'okaka_secret'
  end

  test 'delete user' do
    login_as_okaka
    # delete myself
    assert_difference 'User.count', -1 do
      delete user_path(@okaka.screen_name)
    end
    # automatically logged out when deleting myself
    assert_nil current_user
    # could not find user deleted
    assert_nil User.find_by(screen_name: @okaka.screen_name)

    # check okaka has deleted logically(paranoid)
    okaka_tomb = User.with_deleted.find_by(screen_name: @okaka.screen_name)
    assert okaka_tomb
    assert okaka_tomb.deleted?
  end

  test 'delete other user as admin' do
    login_as_okaka
    # delete others
    assert_difference 'User.count', -1 do
      delete user_path(@noritama.screen_name)
    end
    # not logged out
    assert_equal current_user, @okaka
    # could not find user deleted
    assert_nil User.find_by(screen_name: @noritama.screen_name)

    # check noritama has deleted logically(paranoid)
    noritama_tomb = User.with_deleted
                        .find_by(screen_name: @noritama.screen_name)
    assert noritama_tomb
    assert noritama_tomb.deleted?
  end

  test 'delete other user' do
    # delete others without logging in(failure)
    assert_no_difference 'User.count' do
      delete user_path(@okaka.screen_name)
    end
    login_as_noritama
    # delete others(failure)
    assert_no_difference 'User.count' do
      delete user_path(@okaka.screen_name)
    end
    # not logged out
    assert_equal current_user, @noritama
    # can find user not deleted
    assert User.find_by(screen_name: @noritama.screen_name)
  end
end
