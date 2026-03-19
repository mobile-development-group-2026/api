class CreateStudentProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :student_profiles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.date :date_of_birth
      t.string :gender
      t.string :academic_level
      t.decimal :budget_min, precision: 10, scale: 2
      t.decimal :budget_max, precision: 10, scale: 2
      t.date :move_in_date
      t.integer :noise_level
      t.integer :cleanliness
      t.integer :guests_policy
      t.string :daily_routine
      t.boolean :pets_ok, default: false, null: false
      t.boolean :smoking_ok, default: false, null: false

      t.timestamps
    end
  end
end
