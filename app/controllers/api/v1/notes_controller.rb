module Api
  module V1
    class NotesController < ApplicationController
      def show
        @note = Note.find_by(id: params[:id])
        render json: @note, include: { user: %i[projects request_boxes] }
      end
    end
  end
end
