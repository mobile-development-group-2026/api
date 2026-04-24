module ListingSerializer
  def listing_json(listing)
    sorted_photos = listing.listing_photos.sort_by(&:position)

    {
      id: listing.id,
      user_id: listing.user_id,
      listing_type: listing.listing_type,
      title: listing.title,
      description: listing.description,
      property_type: listing.property_type,
      address: listing.address,
      city: listing.city,
      state: listing.state,
      zip_code: listing.zip_code,
      latitude: listing.latitude,
      longitude: listing.longitude,
      rent: listing.rent,
      security_deposit: listing.security_deposit,
      utilities_included: listing.utilities_included,
      utilities_cost: listing.utilities_cost,
      available_date: listing.available_date,
      lease_term_months: listing.lease_term_months,
      bedrooms: listing.bedrooms,
      bathrooms: listing.bathrooms,
      pets_allowed: listing.pets_allowed,
      parties_allowed: listing.parties_allowed,
      smoking_allowed: listing.smoking_allowed,
      amenities: listing.amenities,
      rules: listing.rules,
      status: listing.status,
      favorites_count: listing.favorites.size,
      views_count: listing.views_count,
      cover_photo_url: sorted_photos.first&.photo_url,
      photos: sorted_photos.map { |p| { id: p.id, photo_url: p.photo_url, position: p.position } },
      created_at: listing.created_at,
      updated_at: listing.updated_at
    }
  end
end
