class WatchlistsController < ApplicationController
  before_action -> { load_note :note_id }, only: %i[create toggle]
  before_action -> { load_watchlist_from_me :id }, only: :destroy

  def create
    # 権限確認
    unless user_can_see? @note, current_user
      render_403
      return
    end

    create_watchlist @note, current_user
  end

  def destroy
    @watchlist.destroy
  end

  def toggle
    # 権限確認
    unless user_can_see? @note, current_user
      render_403
      return
    end
    
    @watchlist = Watchlist.find_by(
      watching_user: current_user,
      watching_note: @note
    )

    if @watchlist.nil?
      create_watchlist @note, current_user
    else
      @watchlist.destroy
      @watchlist = nil
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def create_watchlist(note, user)
    @watchlist = Watchlist.new
    @watchlist.watching_user = user
    @watchlist.watching_note = note
    @watchlist.save!
  end
end
