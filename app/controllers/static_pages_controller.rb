class StaticPagesController < ApplicationController
  def home
    @users = logged_in_users
  end

  def about
  end

  def manage
    #Only admin
    redirect_to root_path and return if !(admin?)
  end
end
