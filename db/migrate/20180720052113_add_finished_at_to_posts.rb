class AddFinishedAtToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :finished_at, :datetime
  end
end
