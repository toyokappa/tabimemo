class AddNoticeFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :level_up, :boolean, default: false, null: false
    add_column :users, :got_trophy_name, :string
  end
end
