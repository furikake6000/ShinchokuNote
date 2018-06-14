class AddViewStanceToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :view_stance, :integer, default: 10
    add_column :notes, :shared_to_public, :boolean, default: true
  end
end
