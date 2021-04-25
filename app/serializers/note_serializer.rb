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

# comment_form_visibility, is_watching, sent_shinchoku_dodeskaの3つのパラメータはN+1を引き起こす可能性があるため、
# ノートを何百件も同時に取得したい場合などは新しいSerializerを作る必要があるかもしれない...
# (現状、一度に取るノートはたかだか10件なのでSerializer分けは保留)

class NoteSerializer < ActiveModel::Serializer
  include NotesHelper

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
             :comments_count,
             :comment_form_visibility,
             :is_watching,
             :sent_shinchoku_dodeska
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

  def comment_form_visibility
    user_can_comment?(object, current_user)
  end

  def is_watching
    current_user ? current_user.watching_notes.include?(object) : false
  end

  def sent_shinchoku_dodeska
    todays_shinchoku_dodeska ||= (
      current_user ? ShinchokuDodeska.todays_shinchoku_dodeska_of_user(object, current_user)
                   : ShinchokuDodeska.todays_shinchoku_dodeska_of_addr(object, instance_options[:current_addr])
    )
    todays_shinchoku_dodeska.present?
  end
end
