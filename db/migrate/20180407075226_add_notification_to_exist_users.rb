class AddNotificationToExistUsers < ActiveRecord::Migration[5.1]
  def up
    Notification.transaction do
      User.find_each do |user|
        user.create_notification
      end
    end
  end

  def down
    Notificaiton.transaction do
      Notification.all
    end
  end
end
