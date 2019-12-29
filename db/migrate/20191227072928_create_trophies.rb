class CreateTrophies < ActiveRecord::Migration[5.1]
  def change
    create_table :trophies do |t|
      t.boolean :plan_count_lv1, default: false, null: false
      t.boolean :plan_count_lv2, default: false, null: false
      t.boolean :plan_count_lv3, default: false, null: false
      t.boolean :plan_count_lv4, default: false, null: false
      t.boolean :pv_count_lv1, default: false, null: false
      t.boolean :pv_count_lv2, default: false, null: false
      t.boolean :pv_count_lv3, default: false, null: false
      t.boolean :pv_count_lv4, default: false, null: false
      t.boolean :like_count_lv1, default: false, null: false
      t.boolean :like_count_lv2, default: false, null: false
      t.boolean :like_count_lv3, default: false, null: false
      t.boolean :like_count_lv4, default: false, null: false
      t.boolean :comment_count_lv1, default: false, null: false
      t.boolean :comment_count_lv2, default: false, null: false
      t.boolean :comment_count_lv3, default: false, null: false
      t.boolean :comment_count_lv4, default: false, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
