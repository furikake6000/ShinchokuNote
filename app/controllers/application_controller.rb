class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :unread_watching_post_num, 
                :newest_notifications_count, 
                :newest_comments_count

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

  def check_logged_in
    redirect_to root_path unless logged_in?
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
    @newest_posts = TweetPost.joins(:note)
                             .where(notes: { shared_to_public: true, view_stance: 'everyone' })
                             .order('created_at DESC')
                             .limit(size)
  end

  def load_watching_posts(size)
    return nil unless logged_in?
    # note_idがwatching_noteであるpostを抽出
    @watching_posts = TweetPost.where('note_id IN (?)', current_user.watching_notes.map(&:id))
                               .order('created_at DESC')
                               .limit(size)
  end

  def load_notifications
    return @notifications if @notifications

    return nil unless logged_in?

    # 自分のノートについたコメントを調べる
    @recent_to_me_comments = Comment.joins(:to_note)
                                    .where(
                                      comments: {
                                        read_flag: false, muted: false 
                                      }, 
                                      notes: {
                                        user_id: current_user.id 
                                      }
                                    )
                                    .where('comments.created_at > ?', current_user.checked_notifications_at)
                                    .order('created_at DESC')

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
    @recent_to_me_comments.each do |c|
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

  def newest_notifications_count
    return 0 unless logged_in?
    return @newest_notifications_count if @newest_notifications_count
    
    newest_comments_count unless @newest_comments_count
    newest_shinchoku_dodeskas_count = ShinchokuDodeska.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.notify_from
    ).count
    newest_watchlists_count = Watchlist.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.notify_from
    ).count

    @newest_notifications_count = @newest_comments_count +
                                  newest_shinchoku_dodeskas_count +
                                  newest_watchlists_count
  end

  def newest_comments_count
    return 0 unless logged_in?
    return @newest_comments_count if @newest_comments_count
    @newest_comments_count = Comment.joins(:to_note)
    .where(
      comments: {
        read_flag: false, muted: false 
      }, 
      notes: {
        user_id: current_user.id
      }
    )
    .where('comments.created_at > ?', current_user.notify_from)
    .count
  end

  # フォロー中のユーザーを取得する
  def load_twitter_friends
    @twitter_friends = []
    return unless logged_in?

    client = client_new
    client.friend_ids.each_slice(1000) do |allfriends|
      @twitter_friends.concat(User.where("twitter_id IN (?)", allfriends.map(&:to_s)))
    end
    @twitter_friends
  end

  # フォロー中のユーザーのポストを取得する
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
