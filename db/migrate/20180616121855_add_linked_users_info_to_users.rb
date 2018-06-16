class AddLinkedUsersInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :linked_users_info, :binary
  end
end
