class StaticPagesController < ApplicationController
  def home
    @users = logged_in_users
  end

  def about
  end
end
