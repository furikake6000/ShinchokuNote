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
    true
  end

  # 403ページ
  def render_403
    render file: Rails.root.join('public/403.html'), status: 403
    true
  end

  def load_user(paramname)
    @user = User.find_by(screen_name: params[paramname].to_s)
    # find_byの場合見つからなくても404を吐いてくれない
    render_404 && return if @user.nil?
  end

  def load_user_as_me(paramname)
    load_user paramname
    render_403 && return unless current_user == @user
  end

  def load_user_as_me_or_admin(paramname)
    load_user paramname
    render_403 && return \
      unless current_user && (current_user == @user || current_user.admin?)
  end

  def load_note(paramname)
    @note = Note.find(params[paramname])
  end

  def load_note_as_mine(paramname)
    load_note paramname
    render_403 && return unless current_user == @note.user
  end

  def load_note_as_mine_or_admin(paramname)
    load_note paramname
    render_403 && return \
      unless current_user && (current_user == @note.user || current_user.admin?)
  end

  def load_post(paramname)
    @post = Post.find(params[paramname])
  end

  def load_post_as_mine(paramname)
    load_post paramname
    render_403 && return unless current_user == @post.note.user
  end

  def load_comments
    # Commentsのアクセス制限
    unless user_can_see_comments? @note, current_user
      @comments = nil
      return
    end

    # Commentsのフィルター機能
    params['comments_filter'] = params['comments_filter'] || 'all'
    case params['comments_filter']
    when 'all' then
      @comments = @note.comments.order('created_at DESC')
    when 'unread' then
      @comments = @note.comments
                       .where(read_flag: false).order('created_at DESC')
    when 'read' then
      @comments = @note.comments
                       .where(read_flag: true).order('created_at DESC')
    when 'favored' then
      @comments = @note.comments
                       .where(favor_flag: true).order('created_at DESC')
    end
  end

  def load_comment(paramname)
    @comment = Comment.find(params[paramname])

    # 存在しない場合は404
    render_404 && return if @comment.nil?
    # Commentsのアクセス制限
    render_403 && return \
      unless user_can_see_comments?(@comment.to_note, current_user) ||
             current_user == @comment.from_user
  end

  def load_comment_from_me(paramname)
    load_comment paramname
    render_403 && return unless current_user == @comment.from_user
  end

  def load_comment_from_me_or_admin(paramname)
    load_comment paramname
    render_403 && return \
      unless current_user &&
             (current_user == @comment.from_user || current_user.admin?)
  end

  def load_comment_to_me(paramname)
    load_comment paramname
    render_403 && return unless current_user == @comment.to_note.user
  end

  def load_watchlist(paramname)
    @watchlist = Watchlist.find(params[paramname])

    # 存在しない場合は404
    render_404 && return if @watchlist.nil?
  end

  def load_watchlist_from_me(paramname)
    load_watchlist paramname
    render_403 && return unless current_user == @watchlist.from_user
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
