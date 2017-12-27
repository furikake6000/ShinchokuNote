class User < ApplicationRecord
  validates :twitter_id, presence: true

  #Omniauth Twitterを用いた認証
  def User.twitter_login(auth)
    User.find_or_create_by(twitter_id: auth[:uid])
  end

  #Cookieに保存された認証情報が正しいものであるか
  #(Twitter IDとAPI User Token, API User Secretsの認証)
  def User.check_cookie(twitter_id)
    raise NotImplementedError.new("Function check_cookie() has not made yet.")
  end

  #現在ログインしているユーザを取得する
  def User.current_user
    raise NotImplementedError.new("Function current_user() has not made yet.")
  end
end
