class ProjectsController < ApplicationController
  before_action :user_collection, only: %i[new create]
  before_action :project_find, only: %i[show edit]
  before_action :project_user_collection, only: %i[edit update]

  def new
    @project = @user.projects.new
  end

  def show
    # before_actionですでに@projectは取得済みなのでなにもしない
  end

  def create
    @project = @user.projects.new(projects_params)
    if @project.save
      # 保存成功
      redirect_to project_path(@project)
    else
      # やりなおし
      render 'new'
    end
  end

  def edit
    # before_actionですでに@projectは取得済みなのでなにもしない
  end

  def update
    if @project.update_attributes(projects_params)
      # 保存成功
      redirect_to project_path(@project)
    else
      # やりなおし
      render 'edit'
    end
  end

  private

  # User取得
  def user_collection
    @user = User.find_by(screen_name: params[:user_id].to_s)
    render_404 && return if @user.nil?
    redirect_to root_path if current_user != @user
  end

  # project取得(自分のproject以外取得できない)
  def project_user_collection
    project_find
    redirect_to root_path if current_user != @project.user
  end

  # project取得
  def project_find
    @project = Project.find_by(id: params[:id])
    render_404 && return if @project.nil?
  end

  # projectのパラメータを安全に取り出す
  def projects_params
    params.require(:project).permit(:type, :name, :desc)
  end
end
