class NoteSerializer < ActiveModel::Serializer
  attributes :type,
             :name,
             :desc,
             :stage,
             :view_stance,
             :rating,
             :watchers_count,
             :shinchoku_dodeskas_count,
             :comments_count
  belongs_to :user
  
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
