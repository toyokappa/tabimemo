class AddPositionToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :position, :integer
  end
end
