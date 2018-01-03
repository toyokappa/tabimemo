class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :plan_id
  end
end
