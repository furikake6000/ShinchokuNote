class ShinchokuDodeska < ApplicationRecord
  belongs_to :from_user, class_name: 'User',
                         foreign_key: 'from_user_id',
                         required: false
  belongs_to :to_note, class_name: 'Note', foreign_key: 'to_note_id'

  enum content: {
    plain: 0,
    otukare: 1,
    suki: 2,
    ouen: 3,
    machimasu: 4
  }
end
