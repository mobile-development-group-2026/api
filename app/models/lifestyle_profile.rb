class LifestyleProfile < ApplicationRecord
  belongs_to :user

  validates :noise_level, inclusion: { in: 1..5 }, allow_nil: true
  validates :cleanliness_level, inclusion: { in: 1..5 }, allow_nil: true
  validates :guest_frequency, inclusion: { in: 1..5 }, allow_nil: true
  validates :sleep_schedule, inclusion: { in: %w[early_bird night_owl flexible] }, allow_nil: true
end
