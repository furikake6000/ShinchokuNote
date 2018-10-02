# == Schema Information
#
# Table name: shinchoku_dodeskas
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  from_addr    :string
#  to_note_id   :integer
#  content      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
