class NotesController < ApplicationController
  before_action :note_user_collection, only: %i[destroy]

  def index
    # Userのshowアクションと同じなのでリダイレクト
    redirect_to user_path(params[:user_id])
  end

  def destroy
    @note.delete
  end

  private

  # User取得
  def user_collection
    @user = User.find_by(screen_name: params[:user_id].to_s)
    render_404 && return if @user.nil?
    redirect_to root_path if current_user != @user
  end

  # Note取得(自分のNote以外取得できない)
  def note_user_collection
    note_find
    redirect_to root_path if current_user != @note.user
  end

  # Note取得
  def note_find
    @note = Note.find_by(id: params[:id])
    render_404 && return if @note.nil?
  end
end
