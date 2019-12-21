class AddExperiencePointToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :experience_point, :integer, null: false, default: 0
  end
end
