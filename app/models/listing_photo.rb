class ListingPhoto < ApplicationRecord
  belongs_to :listing

  validates :photo_url, presence: true
  validate :max_photos_per_listing

  private

  def max_photos_per_listing
    return unless listing

    if listing.listing_photos.count >= 5 && new_record?
      errors.add(:base, "A listing can have a maximum of 5 photos")
    end
  end
end
