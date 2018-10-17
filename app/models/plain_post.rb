# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  text         :string
#  type         :string
#  order        :float
#  note_id      :integer
#  deleted_at   :datetime
#  twitter_id   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  scheduled_at :datetime
#  status       :integer
#  finished_at  :datetime
#

class PlainPost < Post
  acts_as_paranoid

  def sort_condition_date
    created_at
  end
end
