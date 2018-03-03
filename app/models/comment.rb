class Comment < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: true
  belongs_to :to_note, class_name: 'Note', foreign_key: true
  has_one :response, class_name: 'Post'
end
