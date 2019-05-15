class UserBlocksController < ApplicationController
  before_action :check_logged_in

  def create
    @user_block = current_user.user_blocks.new
    target_comment = Comment.find_by(id: user_blocks_params[:comment_id])
    render_404 and return if target_comment.nil?
    
    unless target_comment.from_user.nil?
      @user_block.to_user = target_comment.from_user
    else
      @user_block.to_addr = target_comment.from_addr
    end

    begin
      @user_block.save!
    rescue ActiveRecord::RecordInvalid
      # Blocked same user multiple time
      render_400
    end
  end

  def delete
    @user_block = UserBlock.find(params[:id])
    @user_block.destroy if user_can_delete_user_block?(@user_block, current_user)
  end

  private

  # UserBlockに必要なパラメータを安全に取り出す
  def user_blocks_params
    params.require(:user_block).permit(:comment_id)
  end

  # UserがUserBlockを消せるか？
  def user_can_delete_user_block?(user_block, user)
    return false if user.nil?
    return true if user_block.user == user
    return true if user.admin?
  end
end