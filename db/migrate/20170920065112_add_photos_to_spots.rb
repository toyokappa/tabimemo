class AddPhotosToSpots < ActiveRecord::Migration[5.1]
  def change
    add_column :spots, :photos, :json
  end
end
