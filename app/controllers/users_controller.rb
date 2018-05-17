class UsersController < ApplicationController
  before_action :check_logged_in, only: %i[notifications notifications_checked]
  before_action -> { load_user_as_me_or_admin :id },
                only: %i[edit update destroy]
  before_action -> { load_user_as_me_or_admin :user_id }, only: :leave
  before_action -> { load_user :id }, only: :show
  before_action -> { load_newest_posts 10 }, only: :home
  before_action -> { load_watching_posts 10 }, only: :home
  before_action :load_notifications, only: :notifications

  def index
    # Only admin
    unless admin?
      redirect_to root_path
      return
    end
    @users = User.all
  end

  def new
    if params[:force_login] == 'true'
      redirect_to '/auth/twitter?force_login=true'
    else
      redirect_to '/auth/twitter'
    end
  end

  def edit
    # before_actionですでに@userは取得済みなのでなにもしない
  end

  def update
    if @user.update_attributes(users_params)
      # 保存成功
      redirect_to root_path
    else
      # やりなおし
      render 'edit'
    end
  end

  def show
    # before_actionですでに@userは取得済みなのでなにもしない
  end

  def leave
    # before_actionですでに@userは取得済みなのでなにもしない
  end

  def destroy
    logout_user(@user)
    @user.destroy
  end

  def login
    # auth情報を取り出しログイン
    auth = request.env['omniauth.auth']
    # ログインか新規登録かのチェック
    if User.find_by(twitter_id: auth.uid).nil?
      # 新規登録時の挙動
      unless MYCONF['allow_user_register']
        # 新規登録不可の場合、そのせつを出力
        render 'static_pages/register_denyed'
        return
      end
    end
    twitter_login(auth)
    flash[:success] = 'ログインしました'
    redirect_to root_path
  end

  def logout
    # cookieを削除すればログアウト処理に
    logout_user(current_user)
    flash[:success] = 'ログアウトしました'
    redirect_back(fallback_location: root_path)
  end

  def home
    # 未ログイン状態ならばstatic_pages#homeを描画
    render 'static_pages/home' unless logged_in?

    load_notifications
  end

  def switchuser
    change_current_user_id(params[:id])
    flash[:success] = 'ユーザを切り替えました'
    redirect_back(fallback_location: root_path)
  end

  def updateuser
    user_info_update
    redirect_back fallback_location: user_path(current_user.screen_name)
  end

  def notifications
    # @notifications はbefore_actionですでに読み込んでいる
    return if notifications_num.zero?
  end

  def notifications_checked
    # 通知チェック処理
    current_user.checked_notifications_at = Time.now
    current_user.save!

    redirect_to notifications_path
  end

  private

  # Userのパラメータを安全に取り出す
  def users_params
    params.require(:user).permit(:desc)
  end
end
