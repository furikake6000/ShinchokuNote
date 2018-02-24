class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :name
      t.string :screen_name
      t.string :url
      t.string :thumb_url
      t.string :desc
      t.string :user_group_info
      t.string :permission, default: ''

      t.timestamps
    end
    add_index :users, :twitter_id, unique: true
  end
end
