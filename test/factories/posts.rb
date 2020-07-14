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

FactoryBot.define do
  factory :post do
    type { 'PlainPost' }
    text { Faker::Lorem.paragraph }

    trait :schedule do
      type { 'Schedule' }
      text { Faker::Lorem.word }
      scheduled_at { Time.current.since 7.days }
    end

    trait :finished do
      finished_at { Time.current.ago 1.days }
    end

    # TODO: 必要になったら :with_image のtraitを作成する
  end
end