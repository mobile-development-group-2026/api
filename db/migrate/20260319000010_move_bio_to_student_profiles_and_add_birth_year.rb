class MoveBioToStudentProfilesAndAddBirthYear < ActiveRecord::Migration[8.0]
  def change
    add_column :student_profiles, :bio, :text
    add_column :student_profiles, :birth_year, :integer
    remove_column :users, :bio, :text
  end
end
