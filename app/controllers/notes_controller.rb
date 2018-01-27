class NotesController < ApplicationController
  def index
    #Userのshowアクションと同じなのでリダイレクト
    redirect_to user_path(params[:id])
  end

  def new

  end

  def show

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
