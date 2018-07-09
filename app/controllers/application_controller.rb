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

  require 'tempfile'
  require 'open-uri'

  # rescue_from Exception, with: :render_500
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  # rescue_from OAuth::Unauthorized, with: :render_401

  private

  def check_logged_in
    redirect_to root_path unless logged_in?
  end

  def only_admin
    render_403 && return unless admin?
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
    params['comments_filter'] ||= 'unread'
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

  def load_announce(paramname)
    @announce = Announce.find(params[paramname])

    # 存在しない場合は404
    render_404 && return if @announce.nil?
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
    allowed_types = ['TweetPost', 'PlainPost']
    @watching_posts = Post.where('type IN (?)', allowed_types)
                          .where('note_id IN (?)', current_user.watching_notes.map(&:id))
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
    @newest_shinchoku_dodeskas_count = ShinchokuDodeska.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.notify_from
    ).count
    @newest_watchlists_count = Watchlist.where(
      'to_note_id IN (?) AND created_at > ?',
      current_user.notes.map(&:id),
      current_user.notify_from
    ).count

    @newest_notifications_count = @newest_comments_count +
                                  @newest_shinchoku_dodeskas_count +
                                  @newest_watchlists_count
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

  # paramsからtweetを取得
  def tweetpost_from_params(note)
    client = client_new

    # ツイートを生成
    if params[:post][:twitter_id]
      # Get tweet
      tweet_id = params[:post][:twitter_id].split('/').last
      tweet = client.status(tweet_id, tweet_mode: 'extended')
      # flash
      flash[:success] = 'ツイートをノートに紐付けました！'
    elsif params[:post][:text]
      # Post new tweet

      # 前処理: *を∗に置換する
      posttext = params[:post][:text].tr('*', '∗')

      # 前処理: imageの読み取り
      # imageはblob形式で飛んでくる
      data_urls = params[:post][:image].split(/(?<==),/) if params[:post][:image]

      if params[:post][:response_to]
        # 返信ありの場合
        responded_comment = Comment.find(params[:post][:response_to])
        # 返信先のコメントのテキスト、文字数の最大制限を求める
        # 文字数減少要素: URL, hashtag, コメントの改行, それぞれの間の空白、コメント先頭の'> ''
        responded_comment_maxlen = 140 - 22 - 1 - 6 - 1 - 2 - 2 - posttext.length
        # 必要に応じて載せるコメントを切り貼りする
        if responded_comment_maxlen < 2
          tweetstr = posttext + ' #進捗ノート ' +
                      comment_url(responded_comment, only_path: false)
        else
          responded_comment_text =
            responded_comment.text.length > responded_comment_maxlen ?
            '> ' + responded_comment.text[0..responded_comment_maxlen - 3] + '...' :
            '> ' + responded_comment.text
          responded_comment_text.tr!('*', '∗')

          tweetstr = responded_comment_text + "\n\n" +
                      posttext + ' #進捗ノート ' +
                      comment_url(responded_comment, only_path: false)
        end
        # 画像の有無を判別し投稿
        tweet = data_urls ?
          update_with_media_dataurl(client, tweetstr, data_urls, []) :
          client.update(tweetstr)
      else
        # 返信なしの場合
        # つぶやく文字列を決定
        tweetstr = posttext + "\n" +
                    ' #進捗ノート ' +
                    note_url(@note, only_path: false)
        # 画像の有無を判別し投稿
        tweet = data_urls ?
          update_with_media_dataurl(client, tweetstr, data_urls, []) :
          client.update(tweetstr)
      end

      # もしツイートが切り捨てられていたらフルを持ってくる
      tweet = client.status(tweet.id, tweet_mode: 'extended') if tweet.truncated?

      # flash
      flash[:success] = '新しくツイートを投稿しました！'
    end

    # 投稿したツイートを元にPostを作成
    newpost = tweet_to_tweetpost(tweet, note)

    # URLやタグを取り除き文章のみpostに収納
    tweet_hash = tweet.to_hash
    # 新規ツイートの場合はテキストは全文ではなくフォームに書かれた部分のみ
    tweet_hash['text'] = posttext if posttext
    tweet_hash['full_text'] = posttext if posttext

    # jsonにしてあとでtweetに復元できる形式で保存
    newpost.text = tweet_hash.to_json

    if params[:post][:response_to]
      # Response処理
      newpost.responded_comment = responded_comment

      # responded_commentの既読処理はしておく
      responded_comment.read_flag = true
    end
    newpost
  end

  # TweetからTweetPostオブジェクトを作成する
  def tweet_to_tweetpost(tweet, note)
    tweetpost = note.posts.new(type: 'TweetPost')
    tweetpost.twitter_id = tweet.id
    # Text取得
    tweetpost.text = tweet.to_json
    # 作成したTweetPostを返す
    tweetpost
  end

  # 再帰関数で画像投稿を行う
  private_class_method def update_with_media_dataurl(client, tweetstr, data_urls, pictures)
    if data_urls.empty?
      client.update_with_media tweetstr, pictures
    else
      data_url = data_urls.shift
      image_data_binary = convert_data_url_to_binary data_url

      if image_data_binary.nil?
        # デコードに失敗した場合
        # この画像を無視して再帰
        update_with_media_dataurl client, tweetstr, data_urls, pictures
      else
        Tempfile.create('TwFig') do |f|
          f.binmode
          f.write image_data_binary
          f.rewind
          pictures.push f
          # 再帰
          update_with_media_dataurl client, tweetstr, data_urls, pictures
        end
      end
    end
  end

  # data_urlからimage fileへの変換
  # 参考: (http://www.roughslate.com/convert-data-url-into-image-file-in-ruby-on-rails/)
  private_class_method def convert_data_url_to_binary(data_url)
    split_data = split_base64(data_url)
    return nil if split_data.nil?

    image_data_string = split_data[:data]

    # image data binary
    Base64.decode64(image_data_string)
  end

  def split_base64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      {
        type: $1, # "image/png"
        encoder: $2, # "base64"
        data: $3, # data string
        extension: $1.split('/')[1] # "png"
      }
    end
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
