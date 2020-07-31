module Api
  module V1
    class PostsController < ApplicationController
      def index
        begin
          @note = Note.find(params[:note_id])
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

        render json: @note.posts, root: 'posts', adapter: :json
      end
    end
  end
end
