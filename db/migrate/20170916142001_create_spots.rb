class CreateSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :spots do |t|
      t.string :name, null: false
      t.text :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :required_time
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
