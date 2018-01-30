class NotesController < ApplicationController

  def index
    #Userのshowアクションと同じなのでリダイレクト
    @user = User.find_by(screen_name: params[:user_id].to_s)
    redirect_to user_path(params[:user_id])
  end

  def new
    @user = User.find_by(screen_name: params[:user_id].to_s)
    if current_user != @user
      redirect_to root_path
    end
    @note = @user.notes.new
  end

  def show

  end

  def create
    @note = @user.notes.new(get_notes_params)
    if @note.save
      #保存成功
    else
      #やりなおし
      render 'new'
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
    #Noteのパラメータを安全に取り出す
    def get_notes_params
      params.require(:note).permit(:name, :desc)
    end
end
