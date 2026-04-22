class Listing < ApplicationRecord
  belongs_to :user
  has_many :listing_photos, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  PROPERTY_TYPES = [
    "apartment", "house", "room", "studio",
    "Shared room", "Studio", "1 bedroom", "2 bedrooms", "3+ bedrooms"
  ].freeze

  validates :title, presence: true
  validates :rent, presence: true, numericality: { greater_than: 0 }
  validates :listing_type, presence: true, inclusion: { in: %w[property room] }
  validates :status, presence: true, inclusion: { in: %w[active rented archived] }
  validates :property_type, inclusion: { in: PROPERTY_TYPES }, allow_nil: true

  scope :active, -> { where(status: "active") }
  scope :by_type, ->(type) { where(listing_type: type) if type.present? }
  scope :by_city, ->(city) { where("LOWER(city) = ?", city.downcase) if city.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_bedrooms, ->(count) { where(bedrooms: count) if count.present? }
  scope :min_price, ->(price) { where("rent >= ?", price) if price.present? }
  scope :max_price, ->(price) { where("rent <= ?", price) if price.present? }
end
