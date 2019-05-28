class AddBlockingCommentToUserBlock < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_blocks, :blocking_comment, foreign_key: { to_table: :comments }
  end
end
