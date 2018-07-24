class SchedulesController < ApplicationController
  before_action -> { load_note_as_mine :note_id }, only: %i[create]
  before_action -> { load_post_as_mine :id }, only: %i[edit update destroy]

  def create
    render_400 && return \
      if params[:post][:scheduled_at].nil? && params[:post][:text].empty?

    params[:post][:scheduled_at] = DateTime.strptime(params[:post][:scheduled_at], "%Y/%m/%d %H:%M%z")
    params[:post][:status] = Schedule.statuses[:undone]

    @post = @note.posts.new(schedule_params)

    if @post.save
      # 成功メッセージ
      flash[:success] = '新しいスケジュールを登録しました。'
    else
      # やりなおしメッセージ
      flash[:danger] = 'スケジュールの登録に失敗しました。パラメータが合っているか確認してください。'
    end

    redirect_to note_path(@note)
  end

  def edit
    @post.scheduled_at = @post.scheduled_at.localtime
  end

  def update
    attrs = schedule_updatable_params

    # 完了時刻を刻印
    attrs['finished_at'] = Time.now if attrs['status'] && attrs['status'] == 'done'

    unless @post.update_attributes(attrs)
      # 更新失敗
      flash[:danger] = 'スケジュールの更新に失敗しました。'
    end
    redirect_to note_path(@post.note)
  end

  private

  def schedule_params
    params.require(:post).permit(:text, :type, :scheduled_at, :status)
  end

  def schedule_updatable_params
    params.require(:post).permit(:text, :scheduled_at, :status)
  end
end
