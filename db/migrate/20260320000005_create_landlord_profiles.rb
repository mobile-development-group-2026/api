class CreateLandlordProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :landlord_profiles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :user_id, null: false
      t.integer :birth_year
      t.text :bio
      t.text :hobbies, array: true, default: []

      t.timestamps
    end

    add_index :landlord_profiles, :user_id, unique: true
    add_foreign_key :landlord_profiles, :users
  end
end
