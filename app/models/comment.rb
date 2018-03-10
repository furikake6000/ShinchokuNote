class Comment < ApplicationRecord
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
