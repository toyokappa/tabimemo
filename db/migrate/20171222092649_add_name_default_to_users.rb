class AddNameDefaultToUsers < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :name, :string, default: "", null: false
  end

  def down
    change_column :users, :name, :string, null: false
  end
end
