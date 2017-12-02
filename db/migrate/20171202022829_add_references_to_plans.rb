class AddReferencesToPlans < ActiveRecord::Migration[5.1]
  def change
    add_reference :plans, :user, foreign_key: true
  end
end
