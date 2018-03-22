class TweetPostsController < ApplicationController
  before_action :find_my_note, only: %i[create]

  def create
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
    if params[:post][:twitter_id]
      # Get tweet
      tweet_id = params[:post][:twitter_id].split('/').last
      tweet = client.status(tweet_id)
    elsif params[:post][:text]
      # Post new tweet
      if params[:post][:response_to]
        responded_comment = Comment.find(params[:post][:response_to])
        tweet = client.update(
          '✉️: ' + responded_comment.text +
          "\n💬: " + params[:post][:text] +
          "\n" + comment_url(responded_comment, only_path: false)
        )
      else
        tweet = client.update(params[:post][:text])
      end
    end
    newpost = tweet_to_tweetpost(tweet, note)
    if params[:post][:response_to]
      # Response処理
      newpost.responded_comment = responded_comment
      tweet_hash = tweet.to_hash
      tweet_hash['text'] = params[:post][:text]
      newpost.text = tweet_hash.to_json
    end
    newpost
  end

  # note取得(自分のnote以外取得できない)
  def find_my_note
    find_note
    redirect_to root_path if current_user != @note.user
  end

  # note取得
  def find_note
    @note = Note.find_by(id: params[:note_id])
    render_404 && return if @note.nil?
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
