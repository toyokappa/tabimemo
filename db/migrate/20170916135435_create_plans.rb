class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :published, default: false
      t.integer :view_count, default: 0

      t.timestamps
    end
  end
end
