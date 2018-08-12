class PostsController < ApplicationController

  before_action -> { load_note :note_id }, only: %i[index]
  before_action -> { load_note_as_mine :note_id }, only: %i[create]
  before_action -> { load_post_as_mine :id }, only: %i[destroy]

  def index
    # @noteはbefore_actionで取得済み
  end

  def create
    if params[:post_with_tweet]
      # ツイート投稿あり
      render_400 && return \
        if params[:post][:twitter_id].nil? && params[:post][:text].empty?

      @post = tweetpost_from_params(@note)

    else
      # ツイート投稿なし
      @post = @note.posts.new(posts_params)
      # 返信ありの場合
      if params[:post][:response_to]
        # Response処理
        responded_comment = Comment.find(params[:post][:response_to])
        @post.responded_comment = responded_comment

        # responded_commentの既読処理はしておく
        responded_comment.read_flag = true
      end
      if params[:post][:image]
        params[:post][:image].each do |i|
          @post.media.attach(i[1])
        end
      end
      @post.type = 'PlainPost'
    end

    respond_to do |format|
      if @post.save
        # 保存成功
        format.html { redirect_to note_path(@note) }
        format.js { render json: {}, status: :created }
      else
        # やりなおし
        format.html { render 'notes/show' }
        format.js { render json: {}, status: :internal_server_error }
      end
    end
  end

  def destroy
    note = @post.note
    if ActiveRecord::Type::Boolean.new.cast(
      params.dig(:post, :with_delete_tweet)
    )
      # Delete tweet
      client = client_new
      client.destroy_status(@post.twitter_id)
      # Logical delete
      @post.destroy
    else
      # Logical delete
      @post.destroy
    end
    redirect_to note_path(note)
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
