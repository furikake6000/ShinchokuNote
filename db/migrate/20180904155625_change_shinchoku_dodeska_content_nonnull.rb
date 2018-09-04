class ChangeShinchokuDodeskaContentNonnull < ActiveRecord::Migration[5.2]
  def up
    change_column_null :shinchoku_dodeskas, :content, false, 0
  end

  def down
    change_column_null :shinchoku_dodeskas, :content, true, nil
  end
end
