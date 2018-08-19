class NotesController < ApplicationController
  before_action -> { load_user_as_me :user_id }, only: %i[new create]
  before_action -> { load_note :id }, only: %i[show]
  before_action -> { load_note :note_id }, only: %i[watchers]
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
    render_403 unless user_can_see? @note, current_user
    # before_actionですでに@noteは取得済
    @omakase = params[:omakase]
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

  def watchers; end

  def omakase
    # Noteモデルからランダムに一件取得
    # (参考: https://easyramble.com/get-record-randomly-with-active-record.html)
    count = 0
    while @note.nil?
      # 年齢制限の有無によって変更
      if params[:rating] == 'nolimit'
        @note = Note.where(
          shared_to_public: true,
          view_stance: 'everyone'
        )
        .where('id >= ?', rand(0..Note.last.id))
        .first
      else
        @note = Note.where(
          shared_to_public: true,
          view_stance: 'everyone'
        )
        .where(rating: 'everyone')
        .where('id >= ?', rand(0..Note.last.id))
        .first
      end
      count += 1

      next unless count > 10
      # 無限ループ防衛機構
      alert[:warning] = '条件に合致するノートが見つかりませんでした。条件を変えてお試しください。'
      redirect_to root_path
      return
    end

    redirect_to note_path(@note, omakase: true, rating: params[:rating])
  end

  private

  # Noteのパラメータを安全に取り出す
  def notes_params
    notetype = @note.type.underscore.to_sym unless @note.nil?
    notetype ||= :note
    params.require(notetype).permit(
      :name, :desc, :tags, :stage,
      :view_stance, :shared_to_public,
      :comment_share_stance,
      :comment_receive_stance,
      :thumb_info, :rating
    )
  end
end
