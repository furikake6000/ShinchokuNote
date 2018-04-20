class AddCheckedNotificationsAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :checked_notifications_at, :datetime
  end
end
