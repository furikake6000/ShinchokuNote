class Watchlist < ApplicationRecord
  belongs_to :watching_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :watching_notes, class_name: 'Note', foreign_key: 'to_note_id'
end
