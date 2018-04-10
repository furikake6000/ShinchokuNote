class ShinchokuDodeskasController < ApplicationController
  before_action -> { load_note :note_id }, only: %i[create toggle]

  def create
    @shinchoku_dodeska = ShinchokuDodeska.new
    @shinchoku_dodeska.from_user = current_user
    @shinchoku_dodeska.to_note = @note
    @shinchoku_dodeska.save!
  end

  def destroy
    @shinchoku_dodeska.destroy
  end
end
