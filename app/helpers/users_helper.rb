module UsersHelper
  include ApplicationHelper
  include TwitterHelper

  private

  # ログイン・ログアウト関係

  # ユーザーを指定してログイン
  def login_user(user, token, secret)
    # そもそもそのユーザーでログインしていたなら無視
    return if logged_in_as? user

    # キャッシュの削除
    @current_user = nil
    @master_user = nil

    if logged_in? && user.twitter_id != master_user_id
      # ログインしていたら　マスタユーザーのグループリストを更新
      linked_info = linked_users_info
      linked_info[user.twitter_id] = { 'token' => token, 'secret' => secret }
      linked_users_set(linked_info)
    else
      # ログインしていなかったら　userをマスタユーザーに指定
      set_master_user(user, token, secret)
    end
    # 選択ユーザー(カレントユーザー)を変更
    change_current_user(user)

    # ログインが正しいものであるかチェック(間違っていたらログアウト)
    logout_user(user) unless verify_user_info
  end

  # ユーザーを指定してログアウト
  def logout_user(user)
    # そもそもそのユーザーでログインしていなかったなら無視
    return unless logged_in_as? user

    # キャッシュの削除
    @current_user = nil
    @master_user = nil

    if user == master_user
      # マスタユーザーならば、全ユーザーログアウト
      deletecookie(:currentuserid)
      deletecookie(:masteruserinfo)
    else
      # そのユーザーだけ連携解除
      userinfo = linked_users_info
      userinfo.delete(user.twitter_id)
      linked_users_set(userinfo)
      change_current_user(master_user)
    end
  end

  # 現在ログインしているユーザーのidを全て取得する
  def logged_in_user_ids
    return [] if master_user_id.nil?
    loggedinuserids = linked_users_info.keys
    loggedinuserids.push(master_user_id)
    loggedinuserids
  end

  # 現在ログインしているユーザーを全て取得する
  def logged_in_users
    logged_in_users = []
    logged_in_user_ids.each do |id|
      logged_in_users.push(User.find_by(twitter_id: id))
    end
    logged_in_users
  end

  # ログインしているかどうかを返す
  def logged_in?
    current_user_id.present?
  end

  # 特定のユーザーとしてログインしているかどうかを返す
  def logged_in_as? user
    logged_in_user_ids.include? user.twitter_id
  end

  # カレントユーザー関係
  # カレントユーザー：現在操作しているユーザー

  # カレントユーザーのTwitter IDを取得する
  def current_user_id
    getcookie(:currentuserid)
  end

  # カレントユーザーを取得する
  def current_user
    return nil unless logged_in?
    @current_user ||= logged_in_users.find { |u| u.twitter_id == current_user_id }
  end

  # 該当ユーザーがcurrent_userか否か調べる
  def current_user?(user)
    logged_in? && user == current_user
  end

  # カレントユーザーのinfoを取得する
  def current_user_info
    # linked_users_infoになければmaster_user_info
    linked_users_info[current_user_id] || master_user_info[current_user_id] || {}
  end

  # カレントユーザーのtokenを取得する
  def current_user_token
    current_user_info['token']
  end

  # カレントユーザーのsecretを取得する
  def current_user_secret
    current_user_info['secret']
  end

  # カレントユーザーを変更する
  def change_current_user(user)
    change_current_user_id(user.twitter_id)
  end

  # カレントユーザーのidを変更する
  def change_current_user_id(twitter_id)
    # そのユーザーがユーザー情報テーブル内に存在しなかったらnilを返す（ログインできない）
    # ※currentuserは変わらない
    raise NotLoggedInError unless logged_in_user_ids.include?(twitter_id)
    setcookie(:currentuserid, twitter_id)
  end

  # カレントユーザーがadminユーザーかどうかを返す
  def admin?
    current_user && current_user.admin?
  end

  # マスタユーザー関係
  # マスタユーザー：現在のログインを統括しているユーザー

  # マスタユーザーの情報（IDとトークンの入ったHash）を取得する
  def master_user_info
    # cookieが存在しなければnilを返す
    return {} if getcookie(:masteruserinfo).blank?
    # 存在すればJsonからhashを生成
    hash = JSON.parse(getcookie(:masteruserinfo))
    # マスタユーザーのデータは唯一である（そうでない場合をはじく）
    return {} if hash.size != 1

    hash
  end

  # マスタユーザーのTwitter IDを取得する
  def master_user_id
    master_user_info.nil? ? nil : master_user_info.keys.first
  end

  # マスタユーザーを取得する
  def master_user
    return nil if master_user_id.nil?
    @master_user ||= User.find_by(twitter_id: master_user_id)
  end

  # マスタユーザーのtokenを取得する
  def master_user_token
    master_user_info.empty? ? nil : master_user_info[master_user_id]['token']
  end

  # マスタユーザーのsecretを取得する
  def master_user_secret
    master_user_info.empty? ? nil : master_user_info[master_user_id]['secret']
  end

  # マスタユーザーを変更する
  def set_master_user(user, token, secret)
    masteruserinfo = {}
    masteruserinfo[user.twitter_id] = { token: token, secret: secret }
    setcookie(:masteruserinfo, JSON.generate(masteruserinfo))
  end

  # マスタユーザーに付随するグループを取得
  def linked_users_info
    # まだ情報が登録されていなければ空のHashを返す
    return {} if master_user.nil? || master_user.linked_users_info.nil?
    # パスワードはOAuthシークレット
    pass = master_user_secret
    begin
      json = decrypt_data(master_user.linked_users_info,
                          pass,
                          master_user.salt)
      JSON.parse(json)
    rescue RbNaCl::CryptoError
      flash[:warning] = 'アカウント連携データが読み込めませんでした。' \
                        '「他アカウントへの切り替え」メニューが表示されません(それ以外の機能は問題なくご使用できます。)'
      master_user.linked_users_info = nil
      master_user.save!
      return {}
    end
  end

  # マスタユーザーに付随するグループを設定
  def linked_users_set(info)
    # パスワードはOAuthシークレット
    pass = master_user_secret
    json = JSON.generate(info)
    m = master_user
    m.linked_users_info = encrypt_data(json, pass, master_user.salt).force_encoding('UTF-8')
    m.save!
  end

  # その他の関数

  # Omniauth Twitterを用いた認証
  def twitter_login(auth)
    # authからデータ取り出し
    twitter_id = auth.uid
    token = auth.credentials.token
    secret = auth.credentials.secret

    # もしそのtwitter_idを持つユーザーが存在しなかったらユーザーを作成する
    user = User.find_or_create_by(twitter_id: twitter_id)

    # ユーザーの情報を更新
    user.url = auth.info.urls.Twitter
    user.thumb_url = get_fullsize_thumb_uri(auth.info.image)
    user.screen_name = auth.info.nickname
    user.name = auth.info.name
    user.save!

    login_user(user, token, secret)
  end

  # ユーザーの情報を更新
  def user_info_update
    client = client_new
    user_twitter = client.user(user_id: current_user.twitter_id)

    current_user.url = user_twitter.uri
    current_user.thumb_url = user_twitter.profile_image_uri_https :original
    current_user.screen_name = user_twitter.screen_name
    current_user.name = user_twitter.name
    current_user.save!
  end

  # Cookieに保存された認証情報が正しいものであるか
  # (Twitter IDとAPI User Token, API User Secretsの認証)
  def verify_user_info
    return nil unless logged_in?
    client = client_new
    user_of_me = client.verify_credentials
    user_of_me.id.to_s == current_user.twitter_id
  end
end

# ログインしていないアカウントに対してログインを要する指示を出した時のエラー
class NotLoggedInError < StandardError
end
