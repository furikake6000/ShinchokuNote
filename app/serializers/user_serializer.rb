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

class UserSerializer < ActiveModel::Serializer
  attributes :name,
             :thumb_url,
             :desc
  attribute :screen_name, key: :twitter_screen_name
  attribute :userpage_url, key: :url
  attribute :url, key: :twitter_url
  has_many :recent_projects, key: :projects
  has_many :request_boxes

  def userpage_url
    Rails.application.routes.url_helpers.user_path(object)
  end

  def recent_projects
    object.projects.limit(3)
  end

  def recent_request_boxes
    object.request_boxes.limit(3)
  end
end
