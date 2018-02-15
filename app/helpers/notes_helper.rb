module NotesHelper
  # 該当ノートがcurrent_userのものか否か調べる
  def current_users_note?(note)
    logged_in? && note.user == current_user
  end
end
