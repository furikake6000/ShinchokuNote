# == Schema Information
#
# Table name: comments
#
#  id           :bigint(8)        not null, primary key
#  text         :string
#  read_flag    :boolean          default(FALSE)
#  favor_flag   :boolean          default(FALSE)
#  muted        :boolean          default(FALSE)
#  from_user_id :bigint(8)
#  from_addr    :string
#  to_note_id   :bigint(8)
#  response_id  :bigint(8)
#  anonimity    :integer          default("secret")
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.paragraph }
    from_addr { Faker::Internet.ip_v4_address }

    association :to_note, factory: :project

    trait :from_user do
      from_addr { nil }
      association :from_user, factory: :user
    end

    trait :with_response do
      after(:build) do |comment|
        FactoryBot.create(:post, note: comment.to_note, responded_comment: comment)
      end
    end

    trait :favored do
      favor_flag { true }
    end

    trait :muted do
      muted { true }
    end
  end
end
