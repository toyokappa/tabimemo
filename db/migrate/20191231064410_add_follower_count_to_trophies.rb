class AddFollowerCountToTrophies < ActiveRecord::Migration[5.1]
  def change
    add_column :trophies, :follower_count_lv1, :boolean, default: false, null: false
    add_column :trophies, :follower_count_lv2, :boolean, default: false, null: false
    add_column :trophies, :follower_count_lv3, :boolean, default: false, null: false
    add_column :trophies, :follower_count_lv4, :boolean, default: false, null: false
  end
end
