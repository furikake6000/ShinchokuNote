module Api
  module V1
    class WatchlistsController < ApplicationController
      before_action :load_note
      before_action :check_note_authority

      def create

      end

      def destroy

      end

      private

      def load_note
        begin
          @note = Note.find(params[:note_id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            code: 'note_not_found',
            message: 'ノートが見つかりませんでした。'
          }, status: :not_found
        end
      end

      def check_note_authority
        unless user_can_see? @note, current_user
          render json: {
            code: 'note_forbidden',
            message: 'ノートの閲覧権限がありません。'
          }, status: :forbidden
        end
      end
    end
  end
end
