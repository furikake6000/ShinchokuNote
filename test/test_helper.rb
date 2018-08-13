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
  def login_as_okaka
    @current_user = nil
    @master_user = nil
    login_user @okaka,
               Rails.application.credentials.twitter_test_fixture[:okaka_token],
               Rails.application.credentials.twitter_test_fixture[:okaka_secret]
  end

  def login_as_noritama
    @current_user = nil
    @master_user = nil
    login_user @noritama,
               Rails.application.credentials.twitter_test_fixture[:noritama_token],
               Rails.application.credentials.twitter_test_fixture[:noritama_secret]
  end

  def login_as_noriwasa
    @current_user = nil
    @master_user = nil
    login_user @noriwasa,
               Rails.application.credentials.twitter_test_fixture[:noriwasa_token],
               Rails.application.credentials.twitter_test_fixture[:noriwasa_secret]
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
