class CreateWatchlists < ActiveRecord::Migration[5.1]
  def change
    create_table :watchlists do |t|
      t.references :from_user, null: false
      t.references :to_note, null: false

      t.timestamps
    end

    add_foreign_key :watchlists, :users, column: :from_user_id
    add_foreign_key :watchlists, :notes, column: :to_note_id
  end
end
