class PostsController < ApplicationController
  before_action :find_my_note, only: %i[create]

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

  # note取得(自分のnote以外取得できない)
  def find_my_note
    find_note
    redirect_to root_path if current_user != @note.user
  end

  # note取得
  def find_note
    @note = Note.find_by(id: params[:note_id])
    render_404 && return if @note.nil?
  end

  # Postのパラメータを安全に取り出す
  def posts_params
    posttype = @post.type.downcase.to_sym unless @post.nil?
    posttype ||= :post
    params.require(posttype).permit(:text, :type, :order,
                                    :twitter_id, :media_urls)
  end
end
