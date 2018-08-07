require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
    @okaka_project1 = notes(:okaka_project_1)
    @okaka_tweetpost1 = posts(:okaka_tweet_post_1)
    @okaka_post1 = posts(:okaka_plain_post_1)
    @okaka_schedule1 = posts(:okaka_schedule_1)
    @from_okaka_comment1 = comments(:okaka_to_noritama_comment_1)
    @to_okaka_comment1 = comments(:noritama_to_okaka_comment_1)
  end

  test 'valid user' do
    assert @okaka.valid?
  end

  test 'invalid user uniqueness' do
    dup_user = @okaka.dup
    @okaka.save
    assert_not dup_user.valid?
  end

  test 'invalid user no_twitter_id' do
    @okaka.twitter_id = nil
    assert_not @okaka.valid?
  end

  test 'admin and nonadmin' do
    assert @okaka.admin?
    assert_not @noritama.admin?
  end

  test 'delete and restore user' do
    assert_not @okaka.deleted?
    assert_not @okaka_project1.deleted?
    assert_not @okaka_tweetpost1.deleted?
    assert_not @okaka_post1.deleted?
    assert_not @okaka_schedule1.deleted?
    assert_not @from_okaka_comment1.deleted?
    assert_not @to_okaka_comment1.deleted?

    @okaka.destroy

    assert @okaka.deleted?
    assert @okaka_project1.deleted?
    assert @okaka_tweetpost1.deleted?
    assert @okaka_post1.deleted?
    assert @okaka_schedule1.deleted?
    assert @from_okaka_comment1.deleted?
    assert @to_okaka_comment1.deleted?

    @okaka.restore(recursive: true)

    assert_not @okaka.deleted?
    assert_not @okaka_project1.deleted?
    assert_not @okaka_tweetpost1.deleted?
    assert_not @okaka_post1.deleted?
    assert_not @okaka_schedule1.deleted?
    assert_not @from_okaka_comment1.deleted?
    assert_not @to_okaka_comment1.deleted?
  end

  test 'delete and restore user(deleted note)' do
  end
end
