# == Schema Information
#
# Table name: shinchoku_dodeskas
#
#  id           :bigint(8)        not null, primary key
#  from_user_id :bigint(8)
#  from_addr    :string
#  to_note_id   :bigint(8)
#  content      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :shinchoku_dodeska do
    content { 'plain' }
    from_addr { Faker::Internet.ip_v4_address }

    association :to_note, factory: :project

    trait :from_user do
      association :from_user, factory: :user
    end
  end
end
