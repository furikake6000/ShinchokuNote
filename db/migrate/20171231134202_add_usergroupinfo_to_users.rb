class AddUsergroupinfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_group_info, :string
  end
end
