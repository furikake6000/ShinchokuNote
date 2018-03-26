class CreateShinchokuDodeskas < ActiveRecord::Migration[5.1]
  def change
    create_table :shinchoku_dodeskas do |t|
      t.references :from_user
      t.string :from_addr
      t.references :to_note
      t.integer :content

      t.timestamps
    end
    add_foreign_key :shinchoku_dodeskas, :users, column: :from_user_id
    add_foreign_key :shinchoku_dodeskas, :notes, column: :to_note_id
  end
end
