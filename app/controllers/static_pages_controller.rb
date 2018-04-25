class StaticPagesController < ApplicationController
  before_action -> { load_newest_posts 99 }, only: :home
  
  def home
    @users = logged_in_users
  end

  def about
  end

  def faq
  end

  def manage
    #Only admin
    redirect_to root_path and return if !(admin?)
  end
end
