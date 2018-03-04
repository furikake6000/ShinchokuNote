class Post < ApplicationRecord
  belongs_to :note
  has_one :responded_comment,
          class_name: 'Comment',
          foreign_key: 'response_id',
          optional: true,
          destroy: :nullify
end
