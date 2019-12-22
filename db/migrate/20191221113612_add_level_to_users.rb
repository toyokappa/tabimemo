class AddLevelToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :exp, :integer, null: false, default: 0
    add_column :users, :level, :integer, null: false, default: 1
  end
end
