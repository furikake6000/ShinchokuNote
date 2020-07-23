# == Schema Information
#
# Table name: watchlists
#
#  id           :bigint(8)        not null, primary key
#  from_user_id :bigint(8)
#  to_note_id   :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Watchlist < ApplicationRecord
  belongs_to :watching_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :watching_note, class_name: 'Note', foreign_key: 'to_note_id'

  validates :from_user_id, uniqueness: { scope: :to_note_id }
end
