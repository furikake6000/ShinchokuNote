class TweetPostsController < ApplicationController
  before_action :find_my_note, only: %i[create]

  def create
    client = client_new
    tweet = client.status(params[:post][:twitter_id])
    @post = tweet_to_tweetpost(tweet, @note)
    if @post.save
      # 保存成功
      redirect_to note_path(@note)
    else
      # やりなおし
      render 'notes/show'
    end
  end

  private

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
