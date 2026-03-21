class ChangeHobbiesToArray < ActiveRecord::Migration[8.0]
  def change
    remove_column :student_profiles, :hobbies, :string
    add_column :student_profiles, :hobbies, :text, array: true, default: []
  end
end
