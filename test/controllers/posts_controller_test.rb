require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include UsersHelper

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @noritama_project1 = notes(:noritama_project_1)
    @okaka_tweet_post1 = posts(:okaka_tweet_post_1)
  end
end
