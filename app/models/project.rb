# == Schema Information
#
# Table name: notes
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  desc                   :string
#  type                   :string
#  stage                  :integer          default("in_progress")
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

class Project < Note
  acts_as_paranoid

  enum stage: {
    idea: 0,
    standby: 1,
    in_progress: 2,
    finished: 3,
    frozen: 4,
    closed: 5
  }, _suffix: true
end
