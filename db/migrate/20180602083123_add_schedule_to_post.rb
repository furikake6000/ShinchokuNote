class AddScheduleToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :scheduled_at, :datetime
    add_column :posts, :status, :string
  end
end
