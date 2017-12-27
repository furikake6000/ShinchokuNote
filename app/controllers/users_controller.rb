class UsersController < ApplicationController
  def login
    auth = request.env['omniauth.auth']
    redirect_to root_path
  end
end
