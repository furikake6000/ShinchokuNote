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

class PostSerializer < ActiveModel::Serializer
  attributes :id,
             :type,
             :text
  attribute :created_at, key: :date
  attribute :scheduled_at, key: :scheduled_date, if: :is_schedule?
  attribute :finished_at, key: :finished_date, if: :is_schedule?

  def is_schedule?
    object.type == 'Schedule'
  end

  # TODO: response_postの実装
end
