require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "get index" do
    get :index
    assert_redirected_to(root_path, message="Cant get index without logging in")

    login_user(noritama, "noritama_token", "noritama_secret")
    get :index
    assert_redirected_to(root_path, message="Cant get index with logging in not as admin")

    login_user(okaka, "okaka_token", "okaka_secret")
    get :index
    assert_response(:success, message="Get index with logging in as admin")
  end


end
