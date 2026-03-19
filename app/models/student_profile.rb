class StudentProfile < ApplicationRecord
  belongs_to :user

  validates :noise_level, inclusion: { in: 1..5 }, allow_nil: true
  validates :cleanliness, inclusion: { in: 1..5 }, allow_nil: true
  validates :guests_policy, inclusion: { in: 1..5 }, allow_nil: true
  validates :academic_level, inclusion: { in: %w[undergrad grad phd] }, allow_nil: true
  validates :daily_routine, inclusion: { in: %w[early_bird night_owl flexible] }, allow_nil: true
end
