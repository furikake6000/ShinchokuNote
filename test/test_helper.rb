require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

end

module UsersHelper
  #テスト用に再定義を行う

  #cookie取得
  def getcookie(tag)
    cookies[tag]
  end
  #cookie保存
  def setcookie(tag, value)
    cookies[tag] = value
  end
  #cookie削除
  def deletecookie(tag)
    cookies[tag] = nil
  end
end
