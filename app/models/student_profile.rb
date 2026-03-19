class StudentProfile < ApplicationRecord
  belongs_to :user

  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :graduation_year, numericality: { only_integer: true }, allow_nil: true
end
