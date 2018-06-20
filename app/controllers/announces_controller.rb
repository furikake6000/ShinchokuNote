class AnnouncesController < ApplicationController
  before_action :only_admin, only: %i[create update destroy]
  before_action -> { load_announce :id }, only: %i[update show destroy]

  def index
    @announces = Announce.paginate(page: params[:page])
  end

  def create
    @announce = Announce.new(announces_params)
    if @announce.save
      # 保存成功
      redirect_to root_path
    else
      # やりなおし
      flash[:danger] = 'アナウンスの作成に失敗しました。'
      redirect_to manage_path
    end
  end

  def update
    unless @announce.update_attributes(schedule_updatable_params)
      # 更新失敗
      flash[:danger] = 'アナウンスの更新に失敗しました。'
    end
    redirect_to manage_path
  end

  def show; end

  def destroy
    @announce.destroy
    redirect_to manage_path
  end

  private

  def announces_params
    params.require(:announce).permit(:text, :title)
  end
end
