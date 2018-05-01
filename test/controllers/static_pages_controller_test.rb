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

  test 'access manage' do
    get manage_path
    assert_response 403

    login_as_okaka
    get manage_path
    assert_response :success
    assert_template :manage
  end
end
