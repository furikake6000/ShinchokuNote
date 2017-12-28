module UsersHelper
  #Omniauth Twitterを用いた認証
  def twitter_login(auth)
    #もし存在しなかったらユーザを作成する
    User.find_or_create_by(twitter_id: auth[:uid])

    #ユーザ情報テーブルにユーザ情報を追加
    userinfo = get_userinfo
    userinfo.
  end

  #Cookieに保存された認証情報が正しいものであるか
  #(Twitter IDとAPI User Token, API User Secretsの認証)
  def check_cookie(twitter_id)
    raise NotImplementedError.new("Function check_cookie() has not made yet.")
  end

  #現在ログインしているユーザを取得する
  def current_user
    return nil if cookies.permanent.signed[:currentuserid].nil?
    return @current_user ||= User.find_by(twid: cookies.permanent.signed[:currentuserid])
  end

  #現在選択中のユーザを変更する
  def change_current_user(twitter_id)
    #そのユーザがユーザ情報テーブル内に存在しなかったらnilを返す（ログインできない）
    # ※currentuserは変わらない
    return nil if get_userinfo.has_key?(twitter_id)
    cookies.permanent.signed[:currentuserid] = twitter_id
  end

  #Cookieに保存したJsonからユーザの情報テーブルを取得する
  def get_userinfo
    return {} if cookies.permanent.signed[:userinfo].nil?
    JSON.parse(cookies.permanent.signed[:userinfo])
  end

  #ユーザの情報テーブルをJsonにして保存する
  def set_userinfo(userinfo)
    cookies.permanent.signed[:userinfo] = JSON.generate(userinfo)
  end
end
