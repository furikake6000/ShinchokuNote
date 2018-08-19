class AddRatingToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :rating, :integer, default: 0
  end
end
