class RestructureStudentProfiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :student_profiles, :date_of_birth, :date
    remove_column :student_profiles, :gender, :string
    remove_column :student_profiles, :academic_level, :string
    remove_column :student_profiles, :budget_min, :decimal, precision: 10, scale: 2
    remove_column :student_profiles, :budget_max, :decimal, precision: 10, scale: 2
    remove_column :student_profiles, :move_in_date, :date
    remove_column :student_profiles, :noise_level, :integer
    remove_column :student_profiles, :cleanliness, :integer
    remove_column :student_profiles, :guests_policy, :integer
    remove_column :student_profiles, :daily_routine, :string
    remove_column :student_profiles, :pets_ok, :boolean, default: false, null: false
    remove_column :student_profiles, :smoking_ok, :boolean, default: false, null: false

    add_column :student_profiles, :university, :string
    add_column :student_profiles, :major, :string
    add_column :student_profiles, :age, :integer
    add_column :student_profiles, :graduation_year, :integer
  end
end
