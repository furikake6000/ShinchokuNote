class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :text
      t.string :type
      t.float :order

      t.references :note, foreign_key: true

      # For paranoia
      t.datetime :deleted_at

      # For "TweetPost" < Post
      t.string :twitter_id

      t.timestamps
    end
    add_index :posts, :deleted_at
  end
end
