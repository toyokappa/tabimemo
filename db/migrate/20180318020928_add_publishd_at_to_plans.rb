class AddPublishdAtToPlans < ActiveRecord::Migration[5.1]
  def up
    add_column :plans, :published_at, :datetime
    Plan.update_all("published_at = updated_at")
  end
  
  def down
    remove_column :plans, :published_at, :datetime
  end
end
