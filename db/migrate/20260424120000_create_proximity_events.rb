class CreateProximityEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :proximity_events, id: :uuid do |t|
      t.string :external_id, null: false
      t.uuid :student_id
      t.uuid :listing_id
      t.string :listing_title
      t.string :sector
      t.string :city
      t.string :event_type, default: "entered_radius"
      t.datetime :entered_radius_at
      t.date :event_day
      t.float :latitude
      t.float :longitude
      t.float :radius_meters

      t.timestamps
    end

    add_index :proximity_events, :external_id, unique: true
    add_index :proximity_events, :student_id
    add_index :proximity_events, :listing_id
    add_index :proximity_events, :event_day
    add_index :proximity_events, :sector
  end
end