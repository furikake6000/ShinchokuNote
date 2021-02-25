# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  text         :string
#  type         :string
#  order        :float
#  note_id      :bigint(8)
#  deleted_at   :datetime
#  twitter_id   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  scheduled_at :datetime
#  status       :integer
#  finished_at  :datetime
#

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
    # APIでは使用していない
    done_status? && return_finished_if_done ? finished_date : scheduled_at
  end

  def schedule?
    true
  end
end
