class AddViewsCountToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :views_count, :integer, default: 0, null: false
  end
end
