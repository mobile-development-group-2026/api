class CreateListingProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :listing_profiles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :user_id, null: false
      t.integer :max_budget
      t.string :property_type
      t.date :move_in_date
      t.integer :lease_length_months
      t.integer :max_distance              # 0=500m, 1=1km, 2=2km, 3=any
      t.text :amenities, array: true, default: []
      t.text :preferences, array: true, default: []

      t.timestamps
    end

    add_index :listing_profiles, :user_id, unique: true
    add_foreign_key :listing_profiles, :users
  end
end
