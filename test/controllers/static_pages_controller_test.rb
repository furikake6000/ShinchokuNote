require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include UsersHelper

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

  test 'access faq' do
    get faq_path
    assert_response :success
    assert_template :faq
  end

  test 'nonadmin cannot access manage' do
    get manage_path
    assert_response 403
  end

  test 'admin can access manage' do
    login_for_test create(:user, :admin)
    get manage_path
    assert_response :success
    assert_template :manage
  end
end
