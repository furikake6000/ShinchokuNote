# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  text         :string
#  read_flag    :boolean          default(FALSE)
#  favor_flag   :boolean          default(FALSE)
#  muted        :boolean          default(FALSE)
#  from_user_id :integer
#  from_addr    :string
#  to_note_id   :integer
#  response_id  :integer
#  anonimity    :integer          default("secret")
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  blocked      :boolean          default(FALSE)
#

class Comment < ApplicationRecord
  acts_as_paranoid

  validates :text, presence: true
  validates :to_note, presence: true

  enum anonimity: {
    secret: 0,
    open: 1
  }, _suffix: true

  belongs_to :from_user,
             class_name: 'User',
             foreign_key: 'from_user_id',
             optional: true
  belongs_to :to_note, class_name: 'Note', foreign_key: 'to_note_id'
  belongs_to :response_post,
             class_name: 'Post',
             foreign_key: 'response_id',
             optional: true
end
