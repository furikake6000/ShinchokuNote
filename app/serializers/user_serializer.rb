class UserSerializer < ActiveModel::Serializer
  attributes :name,
             :userpage_url,
             :thumb_url,
             :desc
  attribute :screen_name, key: :twitter_screen_name
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
