class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.boolean :when_like, default: true, null: false
      t.boolean :when_comment, default: true, null: false
      t.boolean :when_news, default: true, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end
