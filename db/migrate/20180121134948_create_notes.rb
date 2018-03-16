class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :name
      t.string :desc
      t.string :type
      t.integer :stage, default: 2 # in progress
      t.string :thumb_info
      t.string :tags
      t.integer :comment_receive_stance, default: 10 # everyone
      t.integer :comment_share_stance, default: 0 # only me

      t.references :user, foreign_key: true

      t.timestamps

      # For "Project" < Note
      t.datetime :started_at
      # For "FinishedProject" < Project
      t.datetime :finished_at
    end
  end
end
