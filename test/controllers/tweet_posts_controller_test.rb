require 'test_helper'

class TweetPostsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper
  include TwitterHelper

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @okaka_tweet_post1 = posts(:okaka_tweet_post_1)
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

  test 'delete post' do
    login_as_okaka

    assert_difference '@okaka_project1.posts.count', -1 do
      delete note_posts_path(@okaka_tweet_post1)
    end

    # Check okaka_post has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Post.find(@okaka_tweet_post1.id)
    end
    # check okaka_post has deleted logically(paranoid)
    okaka_tweet_post1_tomb = Post.with_deleted.find(@okaka_tweet_post1.id)
    assert okaka_tweet_post1_tomb
    assert okaka_tweet_post1_tomb.deleted?
  end

  test 'delete post(with tweet)' do
    login_as_okaka

    client = client_new

    new_tweet_text = random_sentence
    post note_tweet_posts_path(@okaka_project1), params: { post: {
      type: 'TweetPost',
      text: new_tweet_text
    } }
    new_tweetpost = @okaka_project1.posts.last
    new_tweet_id = new_tweetpost.twitter_id

    assert_difference '@okaka_project1.posts.count', -1 do
      delete note_posts_path(new_tweetpost), params: { post: {
          with_delete_tweet: true
      } }
    end

    # Check newpost has deleted
    assert_raises ActiveRecord::RecordNotFound do
      Post.find(new_tweetpost.id)
    end
    # check newpost has deleted physically
    new_tweetpost_tomb = Post.with_deleted.find(new_tweetpost.id)
    assert_nil new_tweetpost_tomb
    # Check newpost has deleted from twitter
    assert_nil client.status(new_tweet_id)
  end

  test 'delete post of others' do
    login_as_noritama

    assert_no_difference '@okaka_project1.posts.count' do
      delete note_posts_path(@okaka_tweet_post1)
    end

    assert_no_difference '@okaka_project1.posts.count' do
      delete note_posts_path(@okaka_tweet_post1), params: { post: {
          with_delete_tweet: true
      } }
    end

    # Check okaka_tweetpost has not deleted
    assert Post.find(@okaka_tweet_post1)
  end
end
