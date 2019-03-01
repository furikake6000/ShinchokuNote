class ShinchokuDodeskasController < ApplicationController
  include ShinchokuDodeskasHelper

  before_action -> { load_note :note_id }, only: %i[create toggle]

  def create
    # 権限確認
    unless user_can_see? @note, current_user
      render_403
      return
    end

    # 一日二回の投稿はできない

    if todays_posted_shinchoku_dodeska(@note, current_user)
      render_403
      return
    end

    # 進捗どうですかの作成
    current_addr = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
    create_shinchoku_dodeska @note,
                             current_user,
                             current_addr,
                             shinchoku_dodeskas_params

    respond_to do |format|
      format.html
      format.js
    end
  end

  def toggle
    # 権限確認
    unless user_can_see? @note, current_user
      render_403
      return
    end

    existing_shinchoku_dodeska = todays_posted_shinchoku_dodeska(@note, current_user)
    if existing_shinchoku_dodeska
      # 既に投稿されていた場合、投稿を削除
      p existing_shinchoku_dodeska
      existing_shinchoku_dodeska.destroy
    else
      # 投稿されていなかった場合、新規作成
      current_addr = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
      create_shinchoku_dodeska @note,
                               current_user,
                               current_addr,
                               shinchoku_dodeskas_params
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @shinchoku_dodeska.destroy
  end

  private

  # shinchoku dodeskaの作成
  def create_shinchoku_dodeska(note, from_user, from_addr, s_params)
    @shinchoku_dodeska = ShinchokuDodeska.new(s_params)
    @shinchoku_dodeska.content ||= 'plain'  # もしcontentが指定されていなければ「plain」を指定
    if !from_user.nil?
      @shinchoku_dodeska.from_user = from_user
    else
      @shinchoku_dodeska.from_addr = from_addr
    end
    @shinchoku_dodeska.to_note = note
    @shinchoku_dodeska.save!

    # Notification
    if note.user.comment_webpush_enabled
      newest_shinchoku_dodeska_to_note_count =
        ShinchokuDodeska.where(to_note: note)
                        .where('created_at > ?', note.user.notify_from)
                        .count
      WebpushService.new(user: note.user)
                    .webpush(
                      "#{note.name}に「#{@shinchoku_dodeska.content_i18n}」が届きました",
                      title: "#{newest_shinchoku_dodeska_to_note_count}件の新しい「進捗どうですか？」"
                    )
    end
  end

  # ShinchokuDodeskaのパラメータを安全に取り出す
  def shinchoku_dodeskas_params
    params.permit(:content)
  end
end
