class ShinchokuDodeskasController < ApplicationController
  include ShinchokuDodeskasHelper

  before_action -> { load_note :note_id }, only: %i[create toggle]

  def create
    # 一日二回の投稿はできない
    return if posted_shinchoku_dodeska_today?(@note, current_user)

    @shinchoku_dodeska = ShinchokuDodeska.new
    @shinchoku_dodeska.from_user = current_user
    @shinchoku_dodeska.to_note = @note
    @shinchoku_dodeska.save!

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @shinchoku_dodeska.destroy
  end
end
