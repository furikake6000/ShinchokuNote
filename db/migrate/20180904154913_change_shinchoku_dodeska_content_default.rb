class ChangeShinchokuDodeskaContentDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_default :shinchoku_dodeskas, :content, nil
  end

  def down
    change_column_default :shinchoku_dodeskas, :content, 0
  end
end
