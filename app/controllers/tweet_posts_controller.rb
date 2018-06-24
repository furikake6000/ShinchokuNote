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
end
