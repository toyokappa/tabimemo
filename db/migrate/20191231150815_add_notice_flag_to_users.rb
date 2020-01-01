class AddNoticeFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :level_up, :boolean, default: false, null: false
  end
end
