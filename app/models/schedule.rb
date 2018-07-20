class Schedule < Post
  acts_as_paranoid

  enum status: {
    undone: 0,
    done: 1
  }, _suffix: true

  validates :text, presence: true
  validates :status, presence: true
  validates :scheduled_at, presence: true

  def finished_date
    return nil unless done_status?
    finished_at || updated_at
  end
  
  def sort_condition_date
    done_status? ? finished_date : scheduled_at
  end
end
