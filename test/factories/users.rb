# == Schema Information
#
# Table name: users
#
#  id                                :bigint(8)        not null, primary key
#  twitter_id                        :string
#  name                              :string
#  screen_name                       :string
#  url                               :string
#  thumb_url                         :string
#  desc                              :string
#  user_group_info                   :string
#  permission                        :string           default("")
#  deleted_at                        :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  checked_notifications_at          :datetime
#  linked_users_info                 :binary
#  saw_notifications_at              :datetime
#  comment_webpush_enabled           :boolean          default(TRUE)
#  shinchoku_dodeska_webpush_enabled :boolean          default(TRUE)
#

FactoryBot.define do
  factory :user do
    transient do
      twitter_user { Faker::Twitter.user }
    end

    twitter_id { twitter_user[:id_str] }
    name { twitter_user[:name] }
    screen_name { twitter_user[:screen_name] }
    thumb_url { "https://picsum.photos/id/#{rand 1000}/400/400" }
    url { twitter_user[:url] }

    desc { Faker::Lorem.paragraph }

    trait :admin do
      permission { 'admin' }
    end
  end
end
