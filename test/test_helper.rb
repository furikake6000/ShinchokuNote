require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/minitest'

module UserTestHelper
  def login_for_test(user, token = 'token', secret = 'secret')
    self.expects(:verify_user_info).returns(true)

    @current_user = nil
    @master_user = nil
    login_user user, token, secret
  end
end

# Add more helper methods to be used by all tests here...

class ActiveSupport::TestCase
  include UserTestHelper
  include FactoryBot::Syntax::Methods
  include Committee::Rails::Test::Methods

  # Setup all fixtures in test/fixtures/*.yml
  # for all tests in alphabetical order.
  fixtures :all

  # ApplicationHelperモジュールの書き換え
  module ApplicationHelperFixes
    # テスト用に再定義を行う

    # cookie取得
    def getcookie(tag)
      cookies[tag.to_s]
    end

    # cookie保存
    def setcookie(tag, value)
      cookies[tag.to_s] = value
    end

    # cookie削除
    def deletecookie(tag)
      cookies.delete(tag.to_s)
    end
  end
  ApplicationHelper.send :prepend, ApplicationHelperFixes

  # committee用のconfig
  def committee_options
    @committee_options ||= {
      schema_path: Rails.root.join('reference', 'api.v1.yaml').to_s,
      prefix: '/api/v1',
      parse_response_by_content_type: false
    }
  end
end
