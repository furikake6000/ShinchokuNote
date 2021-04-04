module Api
  module V1
    class ShinchokuDodeskasController < ApplicationController
      before_action :load_note
      before_action :check_note_authority

      def create
        if todays_shinchoku_dodeska.present?
          render json: {
            code: 'shinchoku_dodeska_already_created',
            message: '本日は既に「進捗どうですか」を投稿しています。'
          }, status: :bad_request
          return
        end

        # contentと宛先データの格納
        params = {
          content: 'plain',
          to_note: @note
        }.merge(shinchoku_dodeskas_params) # contentの値が格納されていれば上書き
        # 送り主データの格納
        if logged_in?
          params[:from_user] = current_user
        else
          params[:from_addr] = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
        end
        # ShinchokuDodeskaの作成
        ShinchokuDodeska.create!(params)

        render json: {
          code: 'success',
          message: '「進捗どうですか」を投稿しました。'
        }, status: :created
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation, ArgumentError
        render json: {
          code: 'invalid_params',
          message: 'パラメータが不正です。'
        }, status: :bad_request
      end

      def destroy
        unless todays_shinchoku_dodeska.present?
          render json: {
            code: 'shinchoku_dodeska_not_created',
            message: '「進捗どうですか」は投稿されていません。'
          }, status: :bad_request
          return
        end

        # ShinchokuDodeskaの削除
        todays_shinchoku_dodeska.destroy

        render json: {
          code: 'success',
          message: '「進捗どうですか」を削除しました。'
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

      # 今日同一のユーザーから@noteに既に投稿された「進捗どうですか」
      def todays_shinchoku_dodeska
        @todays_shinchoku_dodeska ||= (
          logged_in? ? todays_shinchoku_dodeska_of_user(@note, current_user)
                     : todays_shinchoku_dodeska_of_addr(@note, request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip)
        )
      end

      def todays_shinchoku_dodeska_of_user(note, user)
        ShinchokuDodeska.where(from_user: user, to_note: note)
                        .where('created_at > ?', Time.now.beginning_of_day)
                        .to_a.first
      end

      def todays_shinchoku_dodeska_of_addr(note, addr)
        ShinchokuDodeska.where(from_addr: addr, to_note: note)
                        .where('created_at > ?', Time.now.beginning_of_day)
                        .to_a.first
      end

      def shinchoku_dodeskas_params
        params.permit(:content)
      end
    end
  end
end
