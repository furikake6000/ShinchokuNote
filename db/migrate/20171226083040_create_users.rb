class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :name
      t.string :screen_name
      t.string :url
      t.string :thumb_url
      t.string :desc

      t.timestamps
    end
  end
end
