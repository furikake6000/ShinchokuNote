class NotesController < ApplicationController
  before_action :user_collection, only: %i[new create]
  before_action :find_note, only: %i[show]
  before_action :find_my_note, only: %i[edit update destroy]

  def index
    # Userのshowアクションと同じなのでリダイレクト
    redirect_to user_path(params[:user_id])
  end

  def new
    @note = @user.notes.new
  end

  def show
    # typeに合わせてshowの形を変える
    render "#{@note.type.underscore.pluralize}/show"
  end

  def create
    @note = @user.notes.new(notes_params)
    # Typeだけ特別に読み込む（editでは変更が禁止されている）
    @note.type = params[:note][:type]
    if @note.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'new'
    end
  end

  def edit
    # before_actionですでに@noteは取得済みなのでなにもしない
  end

  def update
    if @note.update_attributes(notes_params)
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'edit'
    end
  end

  def destroy
    @note.destroy
  end

  private

  # User取得
  def user_collection
    @user = User.find_by(screen_name: params[:user_id].to_s)
    render_404 && return if @user.nil?
    redirect_to root_path if current_user != @user
  end

  # Note取得(自分のNote以外取得できない)
  def find_my_note
    find_note
    redirect_to root_path if current_user != @note.user
  end

  # Note取得
  def find_note
    @note = Note.find_by(id: params[:id])
    render_404 && return if @note.nil?
  end

  # Noteのパラメータを安全に取り出す
  def notes_params
    notetype = @note.type.underscore.to_sym unless @note.nil?
    notetype ||= :note
    params.require(notetype).permit(
      :name, :desc, :tags, :stage,
      :comment_share_stance,
      :comment_receive_stance,
      :thumb_info
    )
  end
end
