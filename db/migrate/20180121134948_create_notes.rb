class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :name
      t.string :desc
      t.string :type

      t.references :user, foreign_key: true

      t.timestamps

      #For "Project" < Note
      t.datetime :started_at
      #For "FinishedProject" < Project
      t.datetime :finished_at
    end
  end
end
