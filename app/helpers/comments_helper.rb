module CommentsHelper

  # コメントの削除権限
  def user_can_delete_comment?(comment, user)
    return false if comment.response_post
    return false if user.nil?
    return true if user == comment.from_user
    return true if user.admin?
    false
  end

  # コメントを見る権利があるかどうか判定
  def user_can_see_comment?(comment, user)
    # 送信者は閲覧可能
    return true if current_user == comment.from_user

    if comment.response_post.nil?
      # 未返信の場合、コメントの閲覧設定が反映される
      user_can_see_comments? comment.to_note, user
    else
      # 返信済みの場合、ノートの閲覧設定が反映される
      user_can_see? comment.to_note, user
    end
  end
end
