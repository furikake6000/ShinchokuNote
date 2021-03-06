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

        @posts = @note.posts
                      .eager_load(:responded_comment)
                      .with_attached_media
                      .sort_by{ |p| p.schedule? ? p.scheduled_at : p.created_at }
                      .reverse
        @posts = Kaminari.paginate_array(@posts).page(params[:page] || 1).per(30)
        render json: @posts, root: 'posts', adapter: :json, meta: {
          current_page: @posts.current_page,
          total_pages: @posts.total_pages,
          count: @posts.limit_value,
          total_count: @note.posts.count
        }
      end
    end
  end
end
