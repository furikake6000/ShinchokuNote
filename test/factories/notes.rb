
# == Schema Information
#
# Table name: notes
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  desc                   :string
#  type                   :string
#  stage                  :integer          default(2)
#  thumb_info             :string
#  tags                   :string
#  comment_receive_stance :integer          default("everyone")
#  comment_share_stance   :integer          default("only_me")
#  user_id                :bigint(8)
#  started_at             :datetime
#  finished_at            :datetime
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  view_stance            :integer          default("everyone")
#  shared_to_public       :boolean          default(TRUE)
#  rating                 :integer          default("everyone")
#

FactoryBot.define do
  factory :project do
    type { 'Project' }
    stage { :in_progress }
    name { Faker::Lorem.word }
    desc { Faker::Lorem.paragraph }
    view_stance { :everyone }
    comment_receive_stance { :everyone }
    comment_share_stance { :everyone }

    association :user

    after(:build) do |note|
      10.times do
        FactoryBot.create(:post, note: note)
      end
      10.times do
        FactoryBot.create(:comment, to_note: note)
      end
    end
  end

  factory :request_box do
    type { 'RequestBox' }
    name { Faker::Lorem.word }
    desc { Faker::Lorem.paragraph }
    view_stance { :everyone }
    comment_receive_stance { :everyone }
    comment_share_stance { :everyone }

    association :user

    after(:build) do |note|
      10.times do
        FactoryBot.create(:post, note: note)
      end
      10.times do
        FactoryBot.create(:comment, to_note: note)
      end
    end
  end
end
