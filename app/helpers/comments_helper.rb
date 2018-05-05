module CommentsHelper
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

  # コメントの削除権限
  def user_can_delete_comment?(comment, user)
    return false if comment.response_post
    return true if user == comment.from_user
    return true if user.admin?
    false
  end
end
