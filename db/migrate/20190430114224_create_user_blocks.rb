class CreateUserBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_blocks do |t|
      t.references :from_user
      t.references :to_user
      t.string :to_addr

      t.timestamps
    end

    add_foreign_key :user_blocks, :users, column: :from_user_id
    add_foreign_key :user_blocks, :users, column: :to_user_id
  end
end
