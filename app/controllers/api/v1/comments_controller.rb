module Api
  module V1
    class CommentsController < ApplicationController
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

        case params[:filter]
        when 'replied'
          @comments = @note.comments.replied
        when 'unreplied'
          @comments = @note.comments.unreplied
        when 'favored'
          @comments = @note.comments.favored
        else
          @comments = @note.comments
        end

        @comments_page = @comments.page(params[:page] || 1)
        render json: @comments_page, root: 'comments', adapter: :json, meta: {
          current_page: @comments_page.current_page,
          total_pages: @comments_page.total_pages,
          count: @comments_page.size,
          total_count: @note.comments.count
        }
      end
    end
  end
end
