class UsersController < ApplicationController
  def index
    #Only admin
  end

  def new
    redirect_to '/auth/twitter'
  end

  def show
    @user = User.find_by(screen_name: params[:id].to_s)
    render_404 if @user.nil?
  end

  def login
    #auth情報を取り出しログイン
    auth = request.env['omniauth.auth']
    twitter_login(auth)
    redirect_to root_path
  end

  def home
    #未ログイン状態ならばstatic_pages#homeを描画
    if !(logged_in?)
      render 'static_pages/home'
      return
    end
  end

  def switchuser
    change_current_user(params[:id])
    redirect_to root_path
  end
end
