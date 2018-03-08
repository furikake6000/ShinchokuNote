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
    # Type "" means plain post, but it isn't allowed.
    @okaka_tweet_post1.type = ''
    assert_not @okaka_tweet_post1.valid?
  end

  test 'invalid post wrong_type' do
    # Setting wrong type raises ArgumentError.
    assert_raises(ArgumentError) do
      @okaka_tweet_post1.type = 'Undefined'
    end
  end
end
