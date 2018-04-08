class WatchlistsController < ApplicationController
  before_action -> { load_note :note_id }, only: :create
  before_action -> { load_watchlist_from_me :id }, only: :destroy

  def create
    new_watchlist = Watchlist.new
    new_watchlist.watching_user = current_user
    new_watchlist.watching_note = @note
    new_watchlist.save!
  end

  def destroy
    @watchlist.destroy
  end
end
