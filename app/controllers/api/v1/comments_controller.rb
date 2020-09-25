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

        unless user_can_see?(@note, current_user) && user_can_see_comments?(@note, current_user)
          render json: {
            code: 'note_forbidden',
            message: 'ノートの閲覧権限がありません。'
          }, status: :forbidden
          return
        end

        comments = @note.comments.not_muted
        comments_not_blocked = comments - comments.blocked

        case params[:filter]
        when 'replied'
          comments_filtered = comments.replied
        when 'unreplied'
          comments_filtered = comments.unreplied
        when 'favored'
          comments_filtered = comments.favored
        else
          comments_filtered = comments
        end

        # ブロックされているコメントを除外する(SQLが思いつかないための暫定的処理)
        comments_filtered -= comments_filtered.blocked

        @comments_page = Kaminari.paginate_array(comments_filtered).page(params[:page] || 1).per(30)
        render json: @comments_page, root: 'comments', adapter: :json, meta: {
          current_page: @comments_page.current_page,
          total_pages: @comments_page.total_pages,
          count: @comments_page.size,
          total_count: comments_not_blocked.count
        }
      end
    end
  end
end
