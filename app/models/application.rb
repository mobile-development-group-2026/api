class Application < ApplicationRecord
  belongs_to :listing
  belongs_to :student, class_name: "User", foreign_key: :student_id

  STATUSES = %w[pending approved denied].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :student_id, uniqueness: { scope: :listing_id, message: "has already applied to this listing" }

  scope :pending, -> { where(status: "pending") }
  scope :for_landlord, ->(user) {
    joins(:listing).where(listings: { user_id: user.id })
  }
end
