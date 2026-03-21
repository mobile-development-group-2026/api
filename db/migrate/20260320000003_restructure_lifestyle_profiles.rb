class RestructureLifestyleProfiles < ActiveRecord::Migration[8.0]
  def change
    # Remove columns not needed by the UI
    remove_column :lifestyle_profiles, :noise_level, :integer
    remove_column :lifestyle_profiles, :smoking_allowed, :boolean
    remove_column :lifestyle_profiles, :pets_allowed, :boolean
    remove_column :lifestyle_profiles, :parties_allowed, :boolean
    remove_column :lifestyle_profiles, :guest_frequency, :integer
    remove_column :lifestyle_profiles, :move_in_date, :date
    remove_column :lifestyle_profiles, :max_budget, :decimal
    remove_column :lifestyle_profiles, :lifestyle_tags, :text

    # Change sleep_schedule from string to integer (0=early_bird, 1=night_owl, 2=no_preference)
    change_column :lifestyle_profiles, :sleep_schedule, :integer, using: 'NULL'

    # Change cleanliness_level to match UI (0=very_tidy, 1=moderate, 2=relaxed)
    # Reset existing values since scale changed from 1-5 to 0-2
    execute "UPDATE lifestyle_profiles SET cleanliness_level = NULL"

    # Add new columns
    add_column :lifestyle_profiles, :spots_available, :integer, default: 1
    add_column :lifestyle_profiles, :move_in_month, :string
    add_column :lifestyle_profiles, :gender_preference, :integer, default: 0
    add_column :lifestyle_profiles, :lifestyle, :text, array: true, default: []
    add_column :lifestyle_profiles, :requirements, :text, array: true, default: []
  end
end
