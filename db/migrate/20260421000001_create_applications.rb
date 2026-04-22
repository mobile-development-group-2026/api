class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications, id: :uuid do |t|
      t.references :listing, null: false, foreign_key: true, type: :uuid
      t.references :student, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :status, null: false, default: "pending"
      t.datetime :preferred_visit_at
      t.text :student_notes
      t.text :landlord_notes
      t.datetime :reviewed_at
      t.timestamps
    end

    add_index :applications, [ :student_id, :listing_id ], unique: true
  end
end
