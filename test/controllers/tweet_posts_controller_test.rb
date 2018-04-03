require 'test_helper'

class TweetPostsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
  end

  test 'make new tweetpost(link)' do
    login_as_okaka

    assert_difference '@okaka_project1.posts.count', 1 do
      post note_tweet_posts_path(@okaka_project1), params: { post: {
        type: 'TweetPost',
        twitter_id: 'https://twitter.com/okaka_unitest/status/980710729052377088'
      } }
    end

    assert_equal @okaka_project1.posts.last.twitter_id,
                 '980710729052377088'
  end

  test 'make new tweetpost(new)' do
    login_as_okaka

    assert_difference '@okaka_project1.posts.count', 1 do
      post note_tweet_posts_path(@okaka_project1), params: { post: {
        type: 'TweetPost',
        twitter_id: 'https://twitter.com/okaka_unitest/status/980710729052377088'
      } }
    end

    assert_equal @okaka_project1.posts.last.twitter_id,
                 '980710729052377088'
  end

  test 'make new tweetpost as others' do
    login_as_okaka

    new_tweet_text = random_sentence
    assert_difference '@okaka_project1.posts.count', 1 do
      post note_tweet_posts_path(@okaka_project1), params: { post: {
        type: 'TweetPost',
        text: new_tweet_text
      } }
    end

    tweet_info = JSON.parse @okaka_project1.posts.last.text
    assert_equal tweet_info['text'], new_tweet_text
  end
end
