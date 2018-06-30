class AddWebpushOptionsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :comment_webpush_enabled, :boolean, default: true
    add_column :users, :shinchoku_dodeska_webpush_enabled, :boolean, default: true
  end
end
