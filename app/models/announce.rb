# == Schema Information
#
# Table name: announces
#
#  id         :integer          not null, primary key
#  text       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Announce < ApplicationRecord
end
