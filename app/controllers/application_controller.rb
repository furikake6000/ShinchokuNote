class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :unread_watching_post_num, :notifications_num

  include UsersHelper
  include TwitterHelper
  include NotesHelper
  include CommentsHelper
  include ErrorHandlingHelper

  # rescue_from Exception, with: :render_500
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  # rescue_from OAuth::Unauthorized, with: :render_401

  private

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
      @comments = @note.comments
                       .where(muted: false).order('created_at DESC')
      @comments_flag_all = true
    when 'unread' then
      @comments = @note.comments
                       .where(read_flag: false, muted: false).order('created_at DESC')
      @comments_flag_unread = true
    when 'read' then
      @comments = @note.comments
                       .where(read_flag: true, muted: false).order('created_at DESC')
      @comments_flag_read = true
    when 'favored' then
      @comments = @note.comments
                       .where(favor_flag: true, muted: false).order('created_at DESC')
      @comments_flag_favored = true
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
    render_403 && return unless current_user == @watchlist.watching_user
  end

  def load_shinchoku_dodeska(paramname)
    @shinchoku_dodeska = ShinchokuDodeska.find(params[paramname])

    # 存在しない場合は404
    render_404 && return if @shinchoku_dodeska.nil?
  end

  def load_shinchoku_dodeska_from_me(paramname)
    load_shinchoku_dodeska paramname
    render_403 && return unless current_user == @shinchoku_dodeska.from_user
  end

  def load_newest_posts(size)
    @newest_posts = Post.order('created_at DESC').limit(size)
  end

  def load_watching_posts(size)
    return nil unless logged_in?
    # note_idがwatching_noteであるpostを抽出
    @watching_posts = Post.where('note_id IN (?)', current_user.watching_notes.map(&:id))
                          .order('created_at DESC')
                          .limit(size)
  end

  def load_unread_watching_posts(size)
    @unread_posts_loaded_flag = true

    return nil unless logged_in?

    # note_idがwatching_noteであるpostを抽出
    @unread_posts = Post.where(
      'note_id IN (?) AND created_at > ?',
      current_user.watching_notes.map(&:id),
      current_user.checked_notifications_at
    ).order('created_at DESC').limit(size)
  end

  def load_notifications(size)
    return nil if @notifications_loaded_flag
    
    @notifications_loaded_flag = true

    return nil unless logged_in?

    # 自分のノートについたコメントを調べる
    @to_me_comments = Comment.joins(:to_note)
                             .where(notes: { user_id: current_user.id } )
                             .order('created_at DESC')
                             .limit(size)
    @recent_to_me_comments = @to_me_comments.select do |c|
      c.created_at > current_user.checked_notifications_at
    end

    # 自分のノートに新規で付いた進捗どうですかを調べる
    @recent_shinchoku_dodeskas = ShinchokuDodeska.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.checked_notifications_at
    )

    # 自分のノートに新規で付いたウォッチリストを調べる
    @recent_watchlists = Watchlist.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.checked_notifications_at
    )

    @notifications = []
    @to_me_comments.each do |c|
      @notifications << {
        type: 'Comment',
        time: c.created_at,
        content: c
      }
    end

    @recent_shinchoku_dodeskas.group_by(&:to_note).each do |n, s|
      @notifications << {
        type: 'ShinchokuDodeskas',
        time: s.max_by(&:created_at).created_at,
        note: n,
        shinchoku_dodeskas: s
      }
    end
    @recent_watchlists.group_by(&:watching_note).each do |n, w|
      @notifications << {
        type: 'Watchlists',
        time: w.max_by(&:created_at).created_at,
        note: n,
        watchlists: w
      }
    end
    @notifications.sort_by! { |v| v[:time] }.reverse!
  end

  def notifications_num
    return 0 unless logged_in?
    load_notifications 99 unless @notifications_loaded_flag
    @recent_to_me_comments.size + @recent_shinchoku_dodeskas.size + @recent_watchlists.size
  end

  # 未読投稿が何件あるかをカウントする
  def unread_watching_post_num
    load_unread_watching_posts 99 unless @unread_posts_loaded_flag
    @unread_posts.size
  end

  # フォロー中のユーザを取得する
  def load_twitter_friends
    client = client_new
    @twitter_friends = []
    client.friend_ids.each_slice(1000) do |allfriends|
      @twitter_friends.concat(User.where("twitter_id IN (?)", allfriends.map(&:to_s)))
    end
    @twitter_friends
  end

  # フォロー中のユーザのポストを取得する
  def load_twitter_friends_posts(size)
    load_twitter_friends if @twitter_friends.nil?
    # Twitter friendsのnotesのpostsを結合したlist
    friends_notes = @twitter_friends.inject([]) { |result, u| result + u.notes }
    @twitter_friends_posts = friends_notes
                              .inject([]) { |result, n| result + n.posts }[0..size]
                              .sort_by{ |n| n.created_at }
                              .reverse
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
