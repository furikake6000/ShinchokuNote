require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
  end

  test "get index" do

    get users_path
    assert_redirected_to(root_path, message="Cant get index without logging in")

    login_user(@noritama, "noritama_token", "noritama_secret")
    get users_path
    assert_redirected_to(root_path, message="Cant get index with logging in not as admin")

    login_user(@okaka, "okaka_token", "okaka_secret")
    get users_path
    assert_response(:success, message="Get index with logging in as admin")
  end


end
