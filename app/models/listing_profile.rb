class ListingProfile < ApplicationRecord
  belongs_to :user

  validates :max_budget, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :lease_length_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :max_distance, inclusion: { in: 0..3 }, allow_nil: true
end
