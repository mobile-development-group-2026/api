class StudentProfile < ApplicationRecord
  belongs_to :user

  validates :birth_year, numericality: { only_integer: true }, allow_nil: true
  validates :graduation_year, numericality: { only_integer: true }, allow_nil: true
end
