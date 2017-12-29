module UsersHelper
  #Omniauth Twitterを用いた認証
  def twitter_login(auth)
    #authからデータ取り出し
    twitter_id = auth.uid
    token = auth.credentials.token
    secret = auth.credentials.secret

    #もし存在しなかったらユーザを作成する
    user = User.find_or_create_by(twitter_id: twitter_id)

    #ユーザーの情報を更新
    user.url = auth.info.urls.Twitter
    user.thumb_url = auth.info.image
    user.screen_name = auth.info.nickname
    user.name = auth.info.name
    user.save

    #ユーザ情報テーブルにユーザ情報を追加（すでにある場合は更新）
    userinfo = get_userinfo
    userinfo[twitter_id] = {token: token, secret: secret}
    set_userinfo(userinfo)

    #選択ユーザ(カレントユーザ)を変更
    change_current_user(user)
  end

  #Cookieに保存された認証情報が正しいものであるか
  #(Twitter IDとAPI User Token, API User Secretsの認証)
  def check_cookie(twitter_id)
    raise NotImplementedError.new("Function check_cookie() has not made yet.")
  end

  #現在ログインしているユーザを全て取得する
  def logged_in_users
    users = []

    #ユーザ情報テーブルのキーをひとつひとつ見ていく
    userinfo = get_userinfo
    userinfo.each_key do |id|
      #そのユーザが存在すれば配列に追加
      u = User.find_by(twitter_id: id)
      users.push(u) if !(u.nil?)
    end

    return users
  end

  #現在選択中のユーザのTwitter IDを取得する
  def current_user_id
    return cookies.permanent.signed[:currentuserid]
  end

  #現在選択中のユーザを取得する
  def current_user
    return @current_user if !(@current_user.nil?)
    c = current_user_id
    return nil if c.nil?
    return @current_user ||= User.find_by(twitter_id: c)
  end

  #ログインしているかどうかを返す
  def logged_in?
    return !(current_user.nil?)
  end

  #現在選択中のユーザを変更する
  def change_current_user(user)
    #そのユーザがユーザ情報テーブル内に存在しなかったらnilを返す（ログインできない）
    # ※currentuserは変わらない
    return nil if !(get_userinfo.has_key?(user.twitter_id))
    cookies.permanent.signed[:currentuserid] = user.twitter_id
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
