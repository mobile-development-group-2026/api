class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :listing_type, null: false
      t.string :title, null: false
      t.text :description
      t.string :property_type
      t.string :address, null: false
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.decimal :rent, precision: 10, scale: 2, null: false
      t.decimal :security_deposit, precision: 10, scale: 2
      t.boolean :utilities_included, default: false, null: false
      t.decimal :utilities_cost, precision: 10, scale: 2
      t.date :available_date
      t.integer :lease_term_months
      t.integer :bedrooms
      t.integer :bathrooms
      t.boolean :pets_allowed, default: false, null: false
      t.boolean :parties_allowed, default: false, null: false
      t.boolean :smoking_allowed, default: false, null: false
      t.string :status, default: "active", null: false

      t.timestamps
    end

    add_index :listings, :status
    add_index :listings, :listing_type
    add_index :listings, [:latitude, :longitude]
    add_index :listings, :rent
  end
end
