require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @noritama_project1 = notes(:noritama_project_1)
    @okaka_tweet_post1 = posts(:okaka_tweet_post_1)
  end

  test 'valid post' do
    assert @okaka_tweet_post1.valid?
  end

  test 'invalid post no_type' do
    @okaka_tweet_post1.type = ''
    assert_not @okaka_tweet_post1.valid?
  end

  test 'invalid post wrong_type' do
    @okaka_tweet_post1.type = 'Undefined'
    assert_not @okaka_tweet_post1.valid?
  end
end
