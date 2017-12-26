require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "Home test" do
    get root_path
    assert_response :success
  end

  test "About page test" do
    get "/about"
    assert_response :success
  end

end
