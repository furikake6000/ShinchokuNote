module Api
  module V1
    class WatchlistsController < ApplicationController
      before_action :load_note
      before_action :check_note_authority
      before_action :load_watchlist

      def create
        if @watchlist
          render json: {
            code: 'watchlist_already_created',
            message: 'すでにウォッチリストに登録済みです。'
          }, status: :bad_request
          return
        end

        Watchlist.create!(
          watching_user: current_user,
          watching_note: @note
        )
        render json: {
          code: 'watchlist_created',
          message: 'ウォッチリストに登録しました。'
        }, status: :created
      end

      def destroy
        unless @watchlist
          render json: {
            code: 'watchlist_not_created',
            message: 'ウォッチリストに登録されていません。'
          }, status: :bad_request
          return
        end

        @watchlist.destroy!
        render json: {
          code: 'watchlist_deleted',
          message: 'ウォッチリストから解除しました。'
        }, status: :ok
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

      def load_watchlist
        @watchlist = Watchlist.find_by(
          watching_user: current_user,
          watching_note: @note
        )
      end
    end
  end
end
