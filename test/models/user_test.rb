require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @noritama = users(:noritama)
    @okaka = users(:okaka)
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
end
