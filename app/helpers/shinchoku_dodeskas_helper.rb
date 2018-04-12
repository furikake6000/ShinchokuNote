module ShinchokuDodeskasHelper
  def posted_shinchoku_dodeska_today?(note, user)
    ShinchokuDodeska.where(
      '(from_user_id = ?) AND (to_note_id = ?) AND (created_at > ?)',
      user.id,
      note.id,
      Time.now.beginning_of_day
    )
  end
end
