class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.boolean :is_read

      t.integer :from_user_id, null: false
      t.integer :to_note_id, null: false
      t.integer :response_id, null: true

      t.timestamps
    end

    add_index :comment, :from_user_id
    add_index :comment, :to_note_id
  end
end
