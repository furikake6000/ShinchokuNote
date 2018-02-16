require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'Home test' do
    get root_path
    assert_response :success
    assert_template :home
  end

  test 'About page test' do
    get about_path
    assert_response :success
    assert_template :about
  end
end
