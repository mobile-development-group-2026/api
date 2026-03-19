class CreateLifestyleProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :lifestyle_profiles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :user_id, null: false
      t.integer :noise_level
      t.integer :cleanliness_level
      t.string :sleep_schedule
      t.boolean :smoking_allowed, default: false, null: false
      t.boolean :pets_allowed, default: false, null: false
      t.boolean :parties_allowed, default: false, null: false
      t.integer :guest_frequency
      t.text :lifestyle_tags
      t.date :move_in_date
      t.decimal :max_budget, precision: 10, scale: 2
      t.timestamps
    end

    add_index :lifestyle_profiles, :user_id, unique: true
    add_foreign_key :lifestyle_profiles, :users
  end
end
