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
    tweetpost = note.posts.new
    tweetpost.twitter_id = tweet.id
    # Text取得
    tweetpost.text = tweet.full_text
    # メディアURI取得
    # Array->組み合わせArray->Hash->Jsonという長ったらしい変換を行う
    media_url_hash = {}
    unless tweet.uris.empty?
      media_url_array = [[1..tweet.uris.size], tweet.uris].transpose
      media_url_hash = Hash[*media_url_array.flatten]
    end
    tweetpost.media_urls = media_url_hash.to_json
    tweetpost
  end
end
