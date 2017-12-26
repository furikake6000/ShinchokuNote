class User < ApplicationRecord
  validates :twitter_id, presence: true
end
