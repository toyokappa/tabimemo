class ChangeCountDefaultToPageViews < ActiveRecord::Migration[5.1]
  def change
    change_column :page_views, :count, :integer, default: 0, null: false
  end
end
