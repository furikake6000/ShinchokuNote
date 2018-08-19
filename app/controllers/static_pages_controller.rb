class StaticPagesController < ApplicationController
  before_action :only_admin, only: :manage

  layout 'simple', only: %i[help faq terms]

  def home
    @users = logged_in_users
  end

  def about; end

  def faq; end

  def beta; end

  def help; end

  def terms; end

  def manage
    @users = User.paginate(page: params[:page], per_page: 30)
  end
end
