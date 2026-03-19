class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :clerk_id, null: false
      t.string :role, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :avatar_url
      t.text :bio
      t.string :university
      t.boolean :verified, default: false, null: false

      t.timestamps
    end

    add_index :users, :clerk_id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
