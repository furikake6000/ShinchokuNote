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
