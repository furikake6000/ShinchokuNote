class Note < ApplicationRecord
  belongs_to :user
  has_many :posts

  validates :name, presence: true
  validates :type, presence: true
end

class Project < Note

end

class Idea < Note

end

class FinishedProject < Note

end
