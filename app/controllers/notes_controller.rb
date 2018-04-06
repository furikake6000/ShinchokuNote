class NotesController < ApplicationController
  before_action -> { load_user_as_me :user_id }, only: %i[new create]
  before_action -> { load_note :id }, only: %i[show]
  before_action -> { load_comments }, only: %i[show]
  before_action -> { load_note_as_mine_or_admin :id },
                only: %i[edit update destroy]

  def index
    # Userのshowアクションと同じなのでリダイレクト
    redirect_to user_path(params[:user_id])
  end

  def new
    @note = @user.notes.new
  end

  def show
    # before_actionですでに@noteは取得済みなのでなにもしない
  end

  def create
    @note = @user.notes.new(notes_params)
    # Typeだけ特別に読み込む（editでは変更が禁止されている）
    @note.type = params[:note][:type]
    if @note.save
      # 保存成功
      flash[:success] = "ノート「#{@note.name}」の作成に成功しました。"
      redirect_to note_path(@note)
    else
      # やりなおし
      flash.now[:danger] = '作成に失敗しました。'
      render 'new'
    end
  end

  def edit
    # before_actionですでに@noteは取得済みなのでなにもしない
  end

  def update
    if @note.update_attributes(notes_params)
      # 保存成功
      flash[:success] = '変更を適用しました。'
      redirect_to note_path(@note)
    else
      # やりなおし
      flash.now[:danger] = '設定の変更に失敗しました。'
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    redirect_to root_path
  end

  private

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
