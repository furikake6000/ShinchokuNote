class CommentsController < ApplicationController
  before_action :find_note, only: %i[create]

  def create
    @comment = @note.comments.new(comments_params)

    # Comment権限があるか精査
    case @note.comment_receive_stance
    when 'only_signed'
      # "Only signed"ならばログインしていない場合return
      return unless logged_in?
    when 'only_follower'
      # "Only follower"ならばフォローしているか否かの判別を行う
      return unless logged_in?
      client = client_new
      return unless current_users_note?(@note) || client.friendship?(
        current_user.screen_name,
        @note.user.screen_name
      )
    when 'only_me'
      # "Only me"ならば自分のみ許可
      return unless current_users_note?(@note)
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
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  private
  # note取得
  def find_note
    @note = Note.find_by(id: params[:note_id])
    render_404 && return if @note.nil?
  end

  # Commentのパラメータを安全に取り出す
  def comments_params
    params.require(:comment).permit(:text)
  end
end
