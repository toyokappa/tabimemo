class ChangePublishedToPlans < ActiveRecord::Migration[5.1]
  def up
    remove_column :plans, :published
    add_column :plans, :status, :integer, default: 0, null: false
  end

  def down
    add_column :plans, :published, :boolean, default: false
    remove_column :plans, :status
  end
end
