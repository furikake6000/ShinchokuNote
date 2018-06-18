class AddSawNotificationsAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :saw_notifications_at, :datetime
  end
end
