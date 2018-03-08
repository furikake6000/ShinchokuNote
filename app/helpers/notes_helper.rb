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

  # 特定ユーザの構想中プロジェクトのみ取得
  def ideas_of(user)
    user.notes.select { |p| p.type == 'Idea' }
  end

  # 特定ユーザのプロジェクトのみ取得
  def finished_projects_of(user)
    user.notes.select { |p| p.type == 'FinishedProject' }
  end
end
