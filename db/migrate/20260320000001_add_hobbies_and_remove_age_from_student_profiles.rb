class AddHobbiesAndRemoveAgeFromStudentProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :student_profiles, :hobbies, :string
    remove_column :student_profiles, :age, :integer
  end
end
