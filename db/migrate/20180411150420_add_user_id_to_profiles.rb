class AddUserIdToProfiles < ActiveRecord::Migration[5.1]
  def up
    Profile.transaction do
      add_column :profiles, :user_id, :integer
      Profile.update_all("user_id = id")
    end
  end

  def down
    remove_column :profiles, :user_id, :integer
  end
end
