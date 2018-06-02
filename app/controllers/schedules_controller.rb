class SchedulesController < ApplicationController
  before_action -> { load_note_as_mine :note_id }, only: %i[create]

  def create
    render_400 && return if params[:post][:scheduled_at].nil? && params[:post][:text].empty?

    params[:post][:scheduled_at] = DateTime.parse(params[:post][:scheduled_at])
    params[:post][:status] = Schedule.statuses[:undone]

    @schedule = @note.posts.new(schedule_params)
    
    if @schedule.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  private

  def schedule_params
    params.require(:post).permit(:text, :type, :scheduled_at, :status)
  end
end