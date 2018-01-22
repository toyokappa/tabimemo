class AddPositionToSpots < ActiveRecord::Migration[5.1]
  def up
    add_column :spots, :position, :integer

    Plan.all.each do |plan|
      plan.spots.each.with_index(1) do |spot, index|
        spot.update_attribute(:position, index)
      end
    end
  end

  def down
    remove_column :spots, :position, :integer
  end
end
