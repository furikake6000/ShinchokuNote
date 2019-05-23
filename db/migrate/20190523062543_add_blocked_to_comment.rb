class AddBlockedToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :blocked, :boolean, default: false
  end
end
