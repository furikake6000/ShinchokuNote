class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.boolean :read_flag, default: false
      t.boolean :favor_flag, default: false
      t.boolean :muted, default: false

      t.references :from_user
      t.string :from_addr
      t.references :to_note
      t.references :response

      t.integer :anonimity, default: 0

      t.timestamps
    end

    add_foreign_key :comments, :users, column: :from_user_id
    add_foreign_key :comments, :notes, column: :to_note_id
    add_foreign_key :comments, :posts, column: :response_id
  end
end
