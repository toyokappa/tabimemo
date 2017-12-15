class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.text :image
      t.references :spot, foreign_key: true

      t.timestamps
    end
  end
end
