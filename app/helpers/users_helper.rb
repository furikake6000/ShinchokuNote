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

    if logged_in?
      #ログインしていたら　マスタユーザのグループリストを更新
      raise NotImplementedError
    else
      #ログインしていなかったら　userをマスタユーザに指定
      set_master_user(twitter_id, token, secret)
    end

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
    users = master_user.get_user_group_info.keys
    users.push(master_user)
  end

  #マスタユーザの情報（IDとトークンの入ったHash）を取得する
  def master_user_info
    #キャッシュがあればそれを返す
    return @master_user_info_cache if !(@master_user_info_cache.nil?)
    if cookies.permanent.signed[:masteruserinfo].nil?
      #cookieが存在しなければnilを返す
      return nil
    else
      #存在すればJsonからhashを生成
      hash = JSON.parse(cookies.permanent.signed[:masteruserinfo], {:symbolize_names => true})
      #マスタユーザのデータは唯一である（そうでない場合をはじく）
      return nil if hash.size != 1
      #最後キャッシュに保存して返す
      return @master_user_info_cache = hash
    end
  end
  #マスタユーザのTwitter IDを取得する
  def master_user_id
    return nil if master_user_info.nil?
    return master_user_info.keys.first
  end
  #マスタユーザを取得する
  def master_user
    return @master_user if !(@master_user.nil?)
    return nil if master_user_id.nil?
    return @master_user = User.find_by(twitter_id: master_user_id)
  end
  #マスタユーザのtokenを取得する
  def master_user_token
    return nil if master_user_id.nil?
    return master_user_info[master_user_id].token
  end
  #マスタユーザのsecretを取得する
  def master_user_secret
    return nil if master_user_info.nil?
    return master_user_info[master_user_id].secret
  end

  #現在選択中のユーザのTwitter IDを取得する
  def current_user_id
    return cookies.permanent.signed[:currentuserid]
  end
  #現在選択中のユーザを取得する
  def current_user
    return @current_user if !(@current_user.nil?)
    return nil if current_user_id.nil?
    return @current_user = User.find_by(twitter_id: current_user_id)
  end

  #ログインしているかどうかを返す
  def logged_in?
    return !(current_user.nil?)
  end

  private
    #マスタユーザを変更する
    def set_master_user(twitter_id, token, secret)
      masteruserinfo = {}
      masteruserinfo[twitter_id] = {token: token, secret: secret}
      cookie.permanent.signed[:masteruserinfo] = JSON.generate(masteruserinfo)
    end

    #現在選択中のユーザを変更する
    def change_current_user(user)
      #そのユーザがユーザ情報テーブル内に存在しなかったらnilを返す（ログインできない）
      # ※currentuserは変わらない
      return nil if !(get_userinfo.has_key?(user.twitter_id))
      cookies.permanent.signed[:currentuserid] = user.twitter_id
    end
end
