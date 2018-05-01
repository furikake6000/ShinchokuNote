require 'test_helper'

class TwitterHelperTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper
  include TwitterHelper

  def setup
    @okaka = users(:okaka)
  end

  test 'client_new success' do
    # logging in (true token and secret)
    login_as_okaka

    # getting a tweet and collect
    client = client_new
    tweet = client.status('964755775657721857')
    assert_equal tweet.text, 'ぬ'
  end

  test 'client_new failure' do
    # try to get a tweet and assert error
    assert_raises Twitter::Error::Unauthorized do
      # logging in (dummy token and secret)
      login_user @okaka, 'okaka_token', 'okaka_secret'
    end
  end
end
