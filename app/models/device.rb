# == Schema Information
#
# Table name: devices
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  endpoint   :string
#  p256dh     :string
#  auth       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Device < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :endpoint, presence: true, uniqueness: { scope: :user_id }
  validates :p256dh, presence: true
  validates :auth, presence: true
end
