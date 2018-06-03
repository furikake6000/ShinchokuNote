class SchedulesController < ApplicationController
  before_action -> { load_note_as_mine :note_id }, only: %i[create]

  def create
    render_400 && return \
      if params[:post][:scheduled_at].nil? && params[:post][:text].empty?

    params[:post][:scheduled_at] = DateTime.strptime(params[:post][:scheduled_at], "%Y/%m/%d %H:%M%z")
    params[:post][:status] = Schedule.statuses[:undone]

    @schedule = @note.posts.new(schedule_params)

    if @schedule.save
      # 成功メッセージ
      flash[:success] = '新しいスケジュールを登録しました。'
    else
      # やりなおしメッセージ
      flash[:danger] = 'スケジュールの登録に失敗しました。パラメータが合っているか確認してください。'
    end

    redirect_to note_path(@note)
  end

  private

  def schedule_params
    params.require(:post).permit(:text, :type, :scheduled_at, :status)
  end
end
