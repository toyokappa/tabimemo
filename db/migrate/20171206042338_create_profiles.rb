class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string   :name
      t.text     :description
      t.string   :location
      t.string   :url
      t.integer  :gender, limit: 1
      t.date :birthday

      t.timestamps
    end
  end
end
