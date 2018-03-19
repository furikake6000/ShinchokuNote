class CommentsController < ApplicationController
  before_action :find_note, only: %i[create]
  before_action :find_comment, only: %i[show]

  def create
    @comment = @note.comments.new(comments_params)

    return unless user_can_comment?(@note, current_user)

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
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  def show
    # @commentの取得はbefore_actionで完了している
  end

  private
  # note取得
  def find_note
    @note = Note.find_by(id: params[:note_id])
    render_404 && return if @note.nil?
  end

  # comment取得
  def find_comment
    @comment = Comment.find_by(id: params[:id])
    render_404 && return if @comment.nil?
  end

  # Commentのパラメータを安全に取り出す
  def comments_params
    params.require(:comment).permit(:text)
  end
end
