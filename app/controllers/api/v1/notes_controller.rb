module Api
  module V1
    class NotesController < ApplicationController
      def show
        begin
          @note = Note.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            code: 'note_not_found',
            message: 'ノートが見つかりませんでした。'
          }, status: :not_found
          return
        end

        unless user_can_see? @note, current_user
          render json: {
            code: 'note_forbidden',
            message: 'ノートの閲覧権限がありません。'
          }, status: :forbidden
          return
        end

        render json: @note, include: { user: %i[projects request_boxes] }
      end
    end
  end
end
