class AddWhenFollowToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :when_follow, :boolean, default: true, null: false
  end
end
