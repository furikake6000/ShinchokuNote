require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml
  # for all tests in alphabetical order.
  fixtures :all

  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @noriwasa = users(:noriwasa)
  end

  # Add more helper methods to be used by all tests here...
  def test_login(user, token, secret)
    @current_user = nil
    @master_user = nil
    login_user user, token, secret
  end

  def login_as_okaka
    test_login @okaka, 'okaka_token', 'okaka_secret'
  end

  def login_as_noritama
    test_login @noritama, 'noritama_token', 'noritama_secret'
  end

  def login_as_noriwasa
    test_login @noriwasa, 'noriwasa_token', 'noriwasa_secret'
  end

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
end
