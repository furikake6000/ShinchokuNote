# == Schema Information
#
# Table name: shinchoku_dodeskas
#
#  id           :bigint(8)        not null, primary key
#  from_user_id :bigint(8)
#  from_addr    :string
#  to_note_id   :bigint(8)
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

  scope :today, -> { where('created_at > ?', Time.now.beginning_of_day) }

  def self.todays_shinchoku_dodeska_of_user(note, user)
    ShinchokuDodeska.today.where(from_user: user, to_note: note).to_a.first
  end

  def self.todays_shinchoku_dodeska_of_addr(note, addr)
    ShinchokuDodeska.today.where(from_addr: addr, to_note: note).to_a.first
  end
end
