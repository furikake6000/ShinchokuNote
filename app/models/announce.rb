# == Schema Information
#
# Table name: announces
#
#  id         :bigint(8)        not null, primary key
#  text       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Announce < ApplicationRecord
end
