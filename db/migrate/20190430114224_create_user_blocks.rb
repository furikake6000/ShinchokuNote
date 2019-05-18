class CreateUserBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_blocks do |t|
      t.references :user, foreign_key: true
      t.references :blocking_user
      t.string :blocking_addr

      t.timestamps
    end

    add_foreign_key :user_blocks, :users, column: :blocking_user_id
  end
end
