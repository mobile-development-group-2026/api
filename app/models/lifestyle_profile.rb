class LifestyleProfile < ApplicationRecord
  belongs_to :user

  validates :spots_available, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :gender_preference, inclusion: { in: 0..3 }, allow_nil: true
  validates :sleep_schedule, inclusion: { in: 0..2 }, allow_nil: true
  validates :cleanliness_level, inclusion: { in: 0..2 }, allow_nil: true
end
