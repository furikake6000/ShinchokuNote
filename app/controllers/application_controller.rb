class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UsersHelper
  include TwitterHelper
  include NotesHelper

  private

  def load_user(paramname)
    @user = User.find_by(screen_name: params[paramname].to_s)
    # find_byの場合見つからなくても404を吐いてくれない
    render_404 && return if @user.nil?
  end

  def load_user_as_me(paramname)
    load_user paramname
    redirect_to root_path if current_user != @user
  end

  def load_note(paramname)
    @note = Note.find(params[paramname])
  end

  def load_note_as_mine(paramname)
    load_note paramname
    redirect_to root_path if current_user != @note.user
  end

  def load_comment(paramname)
    @comment = Comment.find(params[paramname])
  end

  def load_comment_from_me(paramname)
    load_comment paramname
    redirect_to root_path if current_user != @comment.from_user
  end

  def load_comment_to_me(paramname)
    load_comment paramname
    redirect_to root_path if current_user != @comment.to_note.user
  end
end

#             ξ
#      　　   ll
#      　.＿＿ll＿＿
#      .／ .∽ ..　＼
#      │*　おでば　*│
#      │*　守なぐ　*│
#      │*　りいが　*│
#      │*　　　　　*│ 2018.1.1
#      .￣￣￣￣￣￣
