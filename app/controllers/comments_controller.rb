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
    render_403 unless user_can_see? @note, current_user

    respond_to do |format|
      format.html do
        # htmlの場合はコメント一覧ページを表示
        @current_user_can_comment = user_can_comment? @note, current_user
        @show_comments = true
        @draft = params.permit(:draft)[:draft]
        @rejudge = params.permit(:rejudge)[:rejudge]
        render 'notes/show'
      end
      # jsの場合はajaxでコメントのデータを送信
      format.js
    end
  end

  def create
    recaptcha_v2_flag = params.require(:comment).permit(:recaptcha_v2)[:recaptcha_v2]
    success = recaptcha_v2_flag ?
              verify_recaptcha(secret_key: Rails.application.credentials.recaptcha_v2[:secret]) :
              verify_recaptcha(action: 'social', minimum_score: 0.5)
    unless success
      if recaptcha_v2_flag
        flash[:warning] = 'あなたのコメントはシステムによってbotと判断されました。再度お試しいただき、それでもうまくいかない場合は進捗ノート運営にお問い合わせください。'
      else
        flash[:warning] = 'お手数ですが、「私はロボットではありません」をクリックし、再度投稿してください。'
      end
      redirect_to note_comments_path(@note, draft:comments_params[:text] ,rejudge: true)
      return
    end

    @comment = @note.comments.new(comments_params)

    unless user_can_comment?(@note, current_user)
      flash.now[:danger] = 'ノートの設定でコメントが投稿できませんでした。ノートの所有者にお問い合わせください。'
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
      flash[:success] = 'コメントを投稿しました。'

      # Notification
      if !blocked?(@comment) && @note.user.comment_webpush_enabled
        WebpushService.new(user: @note.user)
                      .webpush(
                        @comment.text,
                        title: "#{@note.name}へのコメント"
                      )
      end

      redirect_to note_path(@note)
    else
      # やりなおし
      flash.now[:danger] = 'コメントの投稿に失敗しました。'
      render 'notes/show'
    end
  end

  def show
    render_403 unless user_can_see_comment? @comment, current_user
    # @commentの取得はbefore_actionで完了している
  end

  def update
    @comment_params = comments_params_editable
    @comment.update_attributes(@comment_params)
    # Updateミスなどの対応は後に

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    note = @comment.to_note
    @comment.destroy if user_can_delete_comment?(@comment, current_user)

    redirect_to note_path(note)
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

  # Commentがブロックされているかの判定
  def blocked?(comment)
    unless comment.from_user.nil?
      # Non anonimized comment
      UserBlock.where(
        user: comment.to_note.user,
        blocking_user: comment.from_user
      ).present?
    else
      # Anonimized comment
      UserBlock.where(
        user: comment.to_note.user,
        blocking_addr: comment.from_addr
      ).present?
    end
  end
end
