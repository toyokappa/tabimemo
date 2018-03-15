class AddIsHeaderToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :is_header, :boolean, default: false, null: false
  end
end
