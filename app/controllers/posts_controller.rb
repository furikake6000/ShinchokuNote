class PostsController < ApplicationController
  before_action -> { load_note_as_mine :note_id }, only: %i[create]

  def create
    @post = @note.posts.new(posts_params)
    if @post.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  private

  # Postのパラメータを安全に取り出す
  def posts_params
    posttype = @post.type.downcase.to_sym unless @post.nil?
    posttype ||= :post
    params.require(posttype).permit(:text, :type, :order,
                                    :twitter_id, :media_urls)
  end
end
