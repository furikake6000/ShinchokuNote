class Device < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :endpoint, presence: true, uniqueness: { scope: :user_id }
  validates :p256dh, presence: true
  validates :auth, presence: true
end
