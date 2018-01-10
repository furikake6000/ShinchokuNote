class UsersController < ApplicationController
  def login
    #auth情報を取り出しログイン
    auth = request.env['omniauth.auth']
    twitter_login(auth)
    redirect_to root_path
  end

  def switchuser
    change_current_user(params[:id])
    redirect_to root_path
  end
end
