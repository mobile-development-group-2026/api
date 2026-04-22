class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :listing_id, null: false
      t.timestamps
    end

    add_index :favorites, [ :user_id, :listing_id ], unique: true
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :listings
  end
end
