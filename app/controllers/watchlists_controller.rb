class WatchlistsController < ApplicationController
  before_action -> { load_note :note_id }, only: %i[create toggle]
  before_action -> { load_watchlist_from_me :id }, only: :destroy

  def create
    @watchlist = Watchlist.new
    @watchlist.watching_user = current_user
    @watchlist.watching_note = @note
    @watchlist.save!
  end

  def destroy
    @watchlist.destroy
  end

  def toggle
    @watchlist = Watchlist.find_by(
      watching_user: current_user,
      watching_note: @note
    )

    if @watchlist.nil?
      create
    else
      @watchlist.destroy
      @watchlist = nil
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
