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

class NoteSerializer < ActiveModel::Serializer
  attributes :type,
             :name,
             :desc,
             :stage,
             :view_stance,
             :rating,
             :url,
             :watch_url,
             :created_at,
             :watchers_count,
             :shinchoku_dodeskas_count,
             :comments_count
  belongs_to :user

  def type
    object.type.downcase
  end

  def url
    Rails.application.routes.url_helpers.note_path(object)
  end

  def watch_url
    Rails.application.routes.url_helpers.note_watchlists_toggle_path(object)
  end
  
  def watchers_count
    object.watchlists.count
  end

  def shinchoku_dodeskas_count
    object.shinchoku_dodeskas.count
  end

  def comments_count
    object.comments.count
  end
end
