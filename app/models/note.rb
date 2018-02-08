class Note < ApplicationRecord
  belongs_to :user
  has_many :posts

  validates :name, presence: true
  validates :type, presence: true
end
