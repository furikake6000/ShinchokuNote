module NotesHelper
  # 該当ノートがcurrent_userのものか否か調べる
  def current_users_note?(note)
    logged_in? && note.user == current_user
  end

  # 特定ユーザのプロジェクトのみ取得
  def projects_of(user)
    user.notes.select { |p| p.type == 'Project' }
  end

  # 特定ユーザのリクエストボックスのみ取得
  def request_boxes_of(user)
    user.notes.select { |p| p.type == 'RequestBox' }
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

  # コメントの権利があるかどうか判定
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

end
