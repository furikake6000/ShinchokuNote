module NotesHelper
  # 該当ノートがcurrent_userのものか否か調べる
  def current_users_note?(note)
    logged_in? && note.user == current_user
  end
  
  # 特定typeのノートリストを抽出
  def notelist_of_type(user, type)
    user.notes.with_type(type).select { |n| user_can_see?(n, current_user)}
  end

  # おまかせパスにランダム文字列を付与したもの
  def omakase_path_with_seed
    omakase_path(random: 'shinchokunote'.chars.shuffle.join)
  end

  # Noteからその色の名前を取得する
  def note_color(note)
    note.type == 'RequestBox' ? 'secondary' : 'primary'
  end

  # 閲覧権限の確認
  def user_can_see?(note, user)
    case note.view_stance
    when 'everyone'
      # "Everyone"ならば誰でもOK
      true
    when 'only_signed'
      # "Only signed"ならばログインしていない場合return
      !user.nil?
    when 'only_follower'
      # "Only follower"ならばフォローしているか否かの判別を行う
      return false if user.nil?
      return true if note.user == user
      raise OAuth::Unauthorized unless logged_in?
      client = client_new
      client.friendship?(user.screen_name, note.user.screen_name)
    when 'only_me'
      # "Only me"ならば自分のみ許可
      note.user == user
    end
  end

  # コメントの権利があるかどうか判定
  def user_can_comment?(note, user)
    case note.comment_receive_stance
    when 'everyone'
      # "Everyone"ならば誰でもOK
      true
    when 'only_signed'
      # "Only signed"ならばログインしていない場合return
      !user.nil?
    when 'only_follower'
      # "Only follower"ならばフォローしているか否かの判別を行う
      return false if user.nil?
      return true if note.user == user
      raise OAuth::Unauthorized unless logged_in?
      client = client_new
      client.friendship?(user.screen_name, note.user.screen_name)
    when 'only_me'
      # "Only me"ならば自分のみ許可
      note.user == user
    end
  end

  # コメントを見る権利があるかどうか判定
  def user_can_see_comments?(note, user)
    case note.comment_share_stance
    when 'everyone'
      # "Everyone"ならば誰でもOK
      true
    when 'only_signed'
      # "Only signed"ならばログインしていない場合return
      !user.nil?
    when 'only_follower'
      # "Only follower"ならばフォローしているか否かの判別を行う
      return false if user.nil?
      return true if note.user == user
      raise OAuth::Unauthorized unless logged_in?
      client = client_new
      client.friendship?(user.screen_name, note.user.screen_name)
    when 'only_me'
      # "Only me"ならば自分のみ許可
      note.user == user
    end
  end

  # ノート作成から現在までの日数
  def how_many_days_since_made(note)
    (Time.now.to_date - note.created_at.to_date).to_i
  end
end
