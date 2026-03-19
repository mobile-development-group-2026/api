class RemoveUniversityFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :university, :string
  end
end
