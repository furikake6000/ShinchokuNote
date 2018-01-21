class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :name
      t.string :desc
      t.string :type

      t.datetime :started_at
      t.datetime :finished_at

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
