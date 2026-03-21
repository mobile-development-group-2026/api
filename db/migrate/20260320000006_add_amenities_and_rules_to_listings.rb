class AddAmenitiesAndRulesToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :amenities, :text, array: true, default: []
    add_column :listings, :rules, :text, array: true, default: []
    change_column_null :listings, :address, true
  end
end
