class UsersController < ApplicationController
  def index
    # Only admin
    redirect_to root_path && return unless admin?
    @users = User.all
  end

  def new
    if params[:force_login] == 'true'
      redirect_to '/auth/twitter?force_login=true'
    else
      redirect_to '/auth/twitter'
    end
  end

  def show
    @user = User.find_by(screen_name: params[:id].to_s)
    render_404 if @user.nil?

    @client = client_new
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
    redirect_to root_path
  end

  def logout
    # cookieを削除すればログアウト処理に
    logout_user(current_user)
    redirect_to root_path
  end

  def home
    # 未ログイン状態ならばstatic_pages#homeを描画
    render 'static_pages/home' unless logged_in?
  end

  def switchuser
    change_current_user_id(params[:id])
    redirect_to root_path
  end
end
