class CreatePageViews < ActiveRecord::Migration[5.1]
  def change
    create_table :page_views do |t|
      t.integer :count
      t.date :date
      t.integer :plan_id

      t.timestamps
    end
  end
end
