class StaticPagesController < ApplicationController
  before_action -> { load_newest_posts 99 }, only: :home

  def home
    @users = logged_in_users
  end

  def about; end

  def faq; end

  def beta; end

  def manage
    # Only admin
    render_403 && return unless admin?

    @users = User.paginate(page: params[:page], per_page: 30)
  end
end
