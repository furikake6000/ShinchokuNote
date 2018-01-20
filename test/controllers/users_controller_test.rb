require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
  end

  test "logging in" do
    #Not logged in at first
    assert_not(logged_in?, message="Not logged in at first")
    assert_nil(current_user, message="No user logged in at first")

    #logging in
    login_user(@noritama, "noritama_token", "noritama_secret")
    assert(logged_in?, message="Checking logged in")
    assert_equal(current_user, @noritama, message="Checking logged in user")

    #logging out
    logout_user(@noritama)
    assert_nil(current_user, message="No user logged in after logged out")
    assert_not(logged_in?, message="Not logged in after logged out")
  end

  test "logging in as admin" do
    #Admin? is false in at first
    assert_not(admin?)

    #logging in not as admin
    login_user(@noritama, "noritama_token", "noritama_secret")
    assert_not(admin?)
    logout_user(@noritama)

    #logging in as admin
    login_user(@okaka, "okaka_token", "okaka_secret")
    assert(admin?)
    logout_user(@okaka)

    #logging out
    assert_not(admin?)
  end

  test "logging in with two accounts" do
    #no master user and current uer at first
    assert_nil(master_user)
    assert_nil(current_user)

    #logging in with an account
    login_user(@noritama, "noritama_token", "noritama_secret")
    assert_equal(master_user, @noritama)
    assert_equal(current_user, @noritama)

    #logging in with second account
    login_user(@okaka, "okaka_token", "okaka_secret")
    assert_equal(master_user, @noritama)
    assert_equal(current_user, @okaka)

    #logging out with second account
    logout_user(@okaka)
    assert_equal(master_user, @noritama)
    assert_equal(current_user, @noritama)

    #logging out with master account
    login_user(@okaka, "okaka_token", "okaka_secret")
    logout_user(@noritama)
    assert_nil(master_user)
    assert_nil(current_user)
  end

  test "getting user index" do
    #Cant get index without logging in
    get users_path
    assert_redirected_to(root_path, message="Cant get index without logging in")
    #Cant get index with logging in not as admin
    login_user(@noritama, "noritama_token", "noritama_secret")
    get users_path
    assert_redirected_to(root_path, message="Cant get index with logging in not as admin")
    #Get index with logging in as admin
    login_user(@okaka, "okaka_token", "okaka_secret")
    get users_path
    assert_response(:success, message="Get index with logging in as admin")
  end

end
