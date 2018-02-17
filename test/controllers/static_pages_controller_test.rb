require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'access root' do
    get root_path
    assert_response :success
    assert_template :home
  end

  test 'access about' do
    get about_path
    assert_response :success
    assert_template :about
  end
end
