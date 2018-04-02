class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UsersHelper
  include TwitterHelper
  include NotesHelper
  include CommentsHelper

  private

  # 404ページ
  def render_404
    render file: Rails.root.join('public/404.html'), status: 404
  end

  # 403ページ
  def render_403
    render file: Rails.root.join('public/403.html'), status: 403
  end

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

  def load_comments
    # Commentsのアクセス制限
    unless user_can_see_comments? @note, current_user
      render_403
    end

    # Commentsのフィルター機能
    params['comments_filter'] = params['comments_filter'] || 'all'
    case params['comments_filter']
    when 'all' then
      @comments = @note.comments.order('updated_at DESC')
    when 'unread' then
      @comments = @note.comments
                       .where(read_flag: false).order('updated_at DESC')
    when 'read' then
      @comments = @note.comments
                       .where(read_flag: true).order('updated_at DESC')
    when 'favored' then
      @comments = @note.comments
                       .where(favor_flag: true).order('updated_at DESC')
    end
  end

  def load_comment(paramname)
    @comment = Comment.find(params[paramname])

    # Commentsのアクセス制限
    unless user_can_see_comments? @comment.to_note, current_user
      render_403
    end
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
