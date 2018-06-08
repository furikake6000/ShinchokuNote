module ShinchokuDodeskasHelper
  def posted_shinchoku_dodeska_today?(note, user)
    unless user.nil?
      # if user logged_in
      ShinchokuDodeska.where(
        '(from_user_id = ?) AND (to_note_id = ?) AND (created_at > ?)',
        user.id,
        note.id,
        Time.now.beginning_of_day
      ).empty?.!
    else
      # if user not logged_in
      ShinchokuDodeska.where(
        '(from_addr = ?) AND (to_note_id = ?) AND (created_at > ?)',
        request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip,
        note.id,
        Time.now.beginning_of_day
      ).empty?.!
    end
  end
end
