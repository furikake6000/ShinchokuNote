class TweetPostsController < ApplicationController
  require 'tempfile'

  before_action -> { load_note_as_mine :note_id }, only: %i[create]

  def create
    render_400 && return if params[:post][:twitter_id].nil? && params[:post][:text].empty?

    @post = tweetpost_from_params(@note)
    if @post.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  private

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
      if params[:post][:response_to]
        # 返信ありの場合
        responded_comment = Comment.find(params[:post][:response_to])
        # 返信先のコメントのテキスト、文字数の最大制限を求める
        # 文字数減少要素: URL, hashtag, コメントの改行, それぞれの間の空白、コメント先頭の'> ''
        responded_comment_maxlen = 140 - 22 - 1 - 6 - 1 - 2 - 2 - params[:post][:text].length
        # 必要に応じて載せるコメントを切り貼りする
        if responded_comment_maxlen < 0
          tweetstr = params[:post][:text] + ' #進捗ノート ' + 
                     comment_url(responded_comment, only_path: false)
        else
          responded_comment_text = 
            responded_comment.text.length > responded_comment_maxlen ?
            '> ' + responded_comment.text[0..responded_comment_maxlen - 3] + '...' :
            '> ' + responded_comment.text

          tweetstr = responded_comment_text + "\n\n" +
                     params[:post][:text] + ' #進捗ノート ' + 
                     comment_url(responded_comment, only_path: false)
        end
        # 画像の有無を判別し投稿
        tweet = params[:post][:image] ?
          client.update_with_media(
            tweetstr,
            params[:post][:image].map(&:tempfile)
          ) :
          client.update(tweetstr)
      else
        # 返信なしの場合
        # つぶやく文字列を決定
        tweetstr = params[:post][:text] + "\n" +
                   ' #進捗ノート ' +
                   note_url(@note, only_path: false)
        # 画像の有無を判別し投稿
        tweet = params[:post][:image] ?
          client.update_with_media(
            tweetstr,
            params[:post][:image].map(&:tempfile)
          ) :
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
    tweet_hash['text'] = params[:post][:text] if params[:post][:text]

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
end
