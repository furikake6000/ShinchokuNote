module CommentsHelper

  # コメントの削除権限
  def user_can_delete_comment?(comment, user)
    return false if comment.response_post
    return false if user.nil?
    return true if user == comment.from_user
    return true if user.admin?
    false
  end
end
