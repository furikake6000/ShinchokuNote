require 'test_helper'

class TwitterHelperTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper
  include TwitterHelper

  def setup
    @okaka = users(:okaka)
  end

  test 'client_new success' do
    # logging in (dummy token and secret)
    login_user @okaka, 'RIGHT_TOKEN', 'RIGHT_SECRET'

    # TODO, get some info from twitter and correct
  end

  test 'client_new failure' do
    # logging in (dummy token and secret)
    login_user @okaka, 'okaka_token', 'okaka_secret'

    # TODO, get some info from twitter and ends in failure
  end
end
