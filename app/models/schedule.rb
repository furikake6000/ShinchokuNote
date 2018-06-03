class Schedule < Post
  acts_as_paranoid

  enum status: {
    undone: 0,
    done: 1
  }, _suffix: true

  validates :text, presence: true
  validates :status, presence: true
  validates :scheduled_at, presence: true

  def sort_condition_date
    scheduled_at
  end
end
