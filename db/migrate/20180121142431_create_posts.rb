class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :text
      t.string :type
      t.float :order

      t.references :note, foreign_key: true

      t.timestamps

      # For "TweetPost" < Post
      t.string :twitter_id
      t.string :media_urls
    end
  end
end
