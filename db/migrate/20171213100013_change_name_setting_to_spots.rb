class ChangeNameSettingToSpots < ActiveRecord::Migration[5.1]
  def up
    change_column :spots, :name, :string, null: true
  end

  def down
    change_column :spots, :name, :string, null: false
  end
end
