class AddScheduleToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :shcheduled_time, :datetime
    add_column :posts, :status, :string
  end
end
