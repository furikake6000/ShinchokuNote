module UsersHelper
  include ApplicationHelper

  private

  # ログイン・ログアウト関係

  # ユーザを指定してログイン
  def login_user(user, token, secret)
    if logged_in? && user.twitter_id != master_user_id
      # ログインしていたら　マスタユーザのグループリストを更新
      group_info = user_group_info
      group_info[user.twitter_id] = { 'token' => token, 'secret' => secret }
      user_group_info_set(group_info)
    else
      # ログインしていなかったら　userをマスタユーザに指定
      set_master_user(user, token, secret)
    end
    # ログイン情報が変化するため、キャッシュを削除
    destroy_caches
    # 選択ユーザ(カレントユーザ)を変更
    change_current_user(user)
  end

  # ユーザを指定してログアウト
  def logout_user(user)
    if user == master_user
      # マスタユーザならば、全ユーザログアウト
      deletecookie(:currentuserid)
      deletecookie(:masteruserinfo)
    else
      # そのユーザだけ連携解除
      userinfo = user_group_info
      userinfo.delete(user.twitter_id)
      user_group_info_set(userinfo)
      change_current_user(master_user)
    end
    # ログイン情報が変化するため、キャッシュを削除
    destroy_caches
  end

  # 現在ログインしているユーザのidを全て取得する
  def logged_in_user_ids
    return [] if master_user.nil?
    loggedinuserids = user_group_info.keys
    loggedinuserids.push(master_user_id)
    loggedinuserids
  end

  # 現在ログインしているユーザを全て取得する
  def logged_in_users
    return @logged_in_users unless @logged_in_users.nil?
    @logged_in_users = []
    logged_in_user_ids.each do |id|
      @logged_in_users.push(User.find_by(twitter_id: id))
    end
    @logged_in_users
  end

  # ログインしているかどうかを返す
  def logged_in?
    !(current_user.nil? || master_user.nil?)
  end

  # カレントユーザ関係
  # カレントユーザ：現在操作しているユーザ

  # カレントユーザのTwitter IDを取得する
  def current_user_id
    getcookie(:currentuserid)
  end

  # カレントユーザを取得する
  def current_user
    return nil if current_user_id.nil?
    @current_user ||=
      logged_in_users.find { |u| u.twitter_id == current_user_id }
  end

  # 該当ユーザがcurrent_userか否か調べる
  def current_user?(user)
    logged_in? && user == current_user
  end

  # カレントユーザのinfoを取得する
  def current_user_info
    # user_group_infoになければmaster_user_info
    user_group_info[current_user_id] || master_user_info[current_user_id] || {}
  end

  # カレントユーザのtokenを取得する
  def current_user_token
    current_user_info['token']
  end

  # カレントユーザのsecretを取得する
  def current_user_secret
    current_user_info['secret']
  end

  # カレントユーザを変更する
  def change_current_user(user)
    change_current_user_id(user.twitter_id)
  end

  # カレントユーザのidを変更する
  def change_current_user_id(twitter_id)
    # そのユーザがユーザ情報テーブル内に存在しなかったらnilを返す（ログインできない）
    # ※currentuserは変わらない
    raise NotLoggedInError unless logged_in_user_ids.include?(twitter_id)
    setcookie(:currentuserid, twitter_id)
  end

  # カレントユーザがadminユーザかどうかを返す
  def admin?
    current_user && current_user.admin?
  end

  # マスタユーザ関係
  # マスタユーザ：現在のログインを統括しているユーザ

  # マスタユーザの情報（IDとトークンの入ったHash）を取得する
  def master_user_info
    # cookieが存在しなければnilを返す
    return {} if getcookie(:masteruserinfo).blank?
    # 存在すればJsonからhashを生成
    hash = JSON.parse(getcookie(:masteruserinfo))
    # マスタユーザのデータは唯一である（そうでない場合をはじく）
    return {} if hash.size != 1
    # 最後キャッシュに保存して返す
    hash
  end

  # マスタユーザのTwitter IDを取得する
  def master_user_id
    master_user_info.nil? ? nil : master_user_info.keys.first
  end

  # マスタユーザを取得する
  def master_user
    return nil if master_user_id.nil?
    @master_user ||= logged_in_users.find { |u| u.twitter_id == master_user_id }
    @master_user ||= User.find_by(twitter_id: master_user_id)
  end

  # マスタユーザのtokenを取得する
  def master_user_token
    master_user_info.empty? ? nil : master_user_info[master_user_id]['token']
  end

  # マスタユーザのsecretを取得する
  def master_user_secret
    master_user_info.empty? ? nil : master_user_info[master_user_id]['secret']
  end

  # マスタユーザを変更する
  def set_master_user(user, token, secret)
    masteruserinfo = {}
    masteruserinfo[user.twitter_id] = { token: token, secret: secret }
    setcookie(:masteruserinfo, JSON.generate(masteruserinfo))
  end

  # マスタユーザに付随するグループを取得
  def user_group_info
    # まだ情報が登録されていなければ空のHashを返す
    return {} if master_user.nil? || master_user.user_group_info.nil?
    # パスワードはOAuthシークレット
    pass = master_user_secret
    json = decrypt_data(master_user.user_group_info,
                        pass,
                        master_user.salt)
    JSON.parse(json)
  end

  # マスタユーザに付随するグループを設定
  def user_group_info_set(group_info)
    # パスワードはOAuthシークレット
    pass = master_user_secret
    json = JSON.generate(group_info)
    master_user.user_group_info =
      encrypt_data(json, pass, master_user.salt).force_encoding('UTF-8')
    master_user.save!
  end

  # その他の関数

  # Omniauth Twitterを用いた認証
  def twitter_login(auth)
    # authからデータ取り出し
    twitter_id = auth.uid
    token = auth.credentials.token
    secret = auth.credentials.secret

    # もしそのtwitter_idを持つユーザが存在しなかったらユーザを作成する
    user = User.find_or_create_by(twitter_id: twitter_id)

    # ユーザーの情報を更新
    user.url = auth.info.urls.Twitter
    user.thumb_url = get_fullsize_thumb_uri(auth.info.image)
    user.screen_name = auth.info.nickname
    user.name = auth.info.name
    user.save

    login_user(user, token, secret)
  end

  # Cookieに保存された認証情報が正しいものであるか
  # (Twitter IDとAPI User Token, API User Secretsの認証)
  def check_cookie
    return nil unless logged_in?
    client = client_new
    user_of_me = client.verify_credentials
    user_of_me.id.to_s == current_user.twitter_id
  end

  # ログイン状態が変化した場合などに、キャッシュ破棄のために呼び出す
  def destroy_caches
    @current_user = nil
    @master_user = nil
    @logged_in_users = nil
  end
end

# ログインしていないアカウントに対してログインを要する指示を出した時のエラー
class NotLoggedInError < StandardError
end
