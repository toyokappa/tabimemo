class RemovePhotosToSpots < ActiveRecord::Migration[5.1]
  def up
    remove_column :spots, :photos
  end

  def down
    add_column :spots, :photos, :json
  end
end
