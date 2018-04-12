class CommentsController < ApplicationController
  include CommentsHelper

  before_action -> { load_note :note_id }, only: %i[index create]
  before_action -> { load_comments }, only: %i[index]
  before_action -> { load_comment :id }, only: %i[show]
  before_action -> { load_comment_to_me :id }, only: %i[update]
  before_action -> { load_comment_from_me_or_admin :id }, only: %i[destroy]

  def index
    # @noteはbefore_actionで取得済み
    # @commentsはbefore_actionで取得済み

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @note.comments.new(comments_params)

    unless user_can_comment?(@note, current_user)
      flash.now[:danger] = 'ノートの設定でコメントが投稿できませんでした。ノートの所有者にお問い合わせください。'
      render 'notes/show'
      return
    end

    # User情報
    if logged_in?
      @comment.from_user = current_user
    else
      @comment.from_addr =
        request.env['HTTP_X_FORWARDED_FOR'] ||
        request.remote_ip
    end
    # Anonimity
    if ActiveRecord::Type::Boolean.new.cast(params[:comment][:anonimity])
      # Anonimity: Open
      @comment.open_anonimity!
    else
      # Anonimity: Secret
      @comment.secret_anonimity!
    end
    if @comment.save
      # 保存成功
      flash[:success] = 'コメントを投稿しました。'
      redirect_to note_path(@note)
    else
      # やりなおし
      flash.now[:danger] = 'コメントの投稿に失敗しました。'
      render 'notes/show'
    end
  end

  def show
    # @commentの取得はbefore_actionで完了している
  end

  def update
    @comment.update_attributes(comments_params_editable)
    # Updateミスなどの対応は後に

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    unless @comment.response_post
      @comment.destroy
    end
  end

  private

  # Commentのパラメータを安全に取り出す
  def comments_params
    params.require(:comment).permit(:text)
  end

  # Commentのパラメータ（edit可能なもの）を安全に取り出す
  def comments_params_editable
    togglable_attributes = %i[read_flag favor_flag muted]

    pa = params.require(:comment).permit(:read_flag, :favor_flag, :muted)
    # togglableかつ'toggle'になっている要素はすべて処理
    togglable_attributes.each do |a|
      pa[a] = !@comment[a] if pa[a] == 'toggle'
    end
    pa
  end
end
