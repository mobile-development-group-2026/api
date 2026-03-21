class SeedLandlordListings < ActiveRecord::Migration[8.0]
  def up
    # Use the target landlord if present, otherwise fall back to any landlord in the DB
    landlord_id = if User.exists?("b53abefe-a5c1-4e6a-ab0b-878ee6e20468")
                    "b53abefe-a5c1-4e6a-ab0b-878ee6e20468"
                  else
                    User.find_by(role: "landlord")&.id
                  end
    return unless landlord_id

    listings = [
      { title: "Bright Studio near Chapinero", property_type: "Studio", rent: 1_800_000, security_deposit: 500_000, lease_term_months: 12, available_date: "2026-08-01", address: "Cra. 13 #54-10", city: "Bogota", state: "Cundinamarca", description: "Cozy studio with natural light, walking distance to universities. Includes WiFi and water.", amenities: "{WiFi,Laundry,Furnished}", rules: "{\"No smoking\",\"Quiet after 10 pm\"}" },
      { title: "2BR Apartment in Teusaquillo", property_type: "2 bedrooms", rent: 2_200_000, security_deposit: 700_000, lease_term_months: 12, available_date: "2026-07-15", address: "Cl. 45 #19-32", city: "Bogota", state: "Cundinamarca", description: "Spacious two-bedroom apartment with balcony and great natural lighting. Near Parque Simon Bolivar.", amenities: "{WiFi,Laundry,Balcony,Parking}", rules: "{\"No smoking\",\"No pets\"}" },
      { title: "Modern Loft near Parque Nacional", property_type: "1 bedroom", rent: 2_500_000, security_deposit: 800_000, lease_term_months: 6, available_date: "2026-09-01", address: "Cra. 5 #39-50", city: "Bogota", state: "Cundinamarca", description: "Modern loft with high ceilings and open floor plan. Perfect for a graduate student.", amenities: "{WiFi,AC,Gym,Furnished}", rules: "{\"No parties\",\"No smoking\"}" },
      { title: "Shared Room near Javeriana", property_type: "Shared room", rent: 1_300_000, security_deposit: 300_000, lease_term_months: 6, available_date: "2026-08-15", address: "Cl. 41 #7-43", city: "Bogota", state: "Cundinamarca", description: "Private room in a shared apartment. Common areas include kitchen and living room. Utilities included.", amenities: "{WiFi,Laundry,Furnished}", rules: "{\"No smoking\",\"Students only\"}" },
      { title: "Penthouse Studio in Zona G", property_type: "Studio", rent: 3_200_000, security_deposit: 1_000_000, lease_term_months: 12, available_date: "2026-07-01", address: "Cl. 69 #6-20", city: "Bogota", state: "Cundinamarca", description: "Luxury studio with rooftop access and city views. Fully furnished with premium appliances.", amenities: "{WiFi,AC,Gym,Pool,Furnished}", rules: "{\"No parties\",\"No smoking\",\"No pets\"}" },
      { title: "Cozy 1BR in La Candelaria", property_type: "1 bedroom", rent: 1_500_000, security_deposit: 400_000, lease_term_months: 6, available_date: "2026-08-01", address: "Cra. 3 #12-45", city: "Bogota", state: "Cundinamarca", description: "Charming apartment in the historic district. Walking distance to Universidad de los Andes.", amenities: "{WiFi,Furnished}", rules: "{\"No smoking\"}" },
      { title: "3BR Family Apartment Suba", property_type: "3+ bedrooms", rent: 2_800_000, security_deposit: 900_000, lease_term_months: 12, available_date: "2026-09-15", address: "Av. Suba #115-30", city: "Bogota", state: "Cundinamarca", description: "Large three-bedroom apartment ideal for a group of students. Each room has a lock. Near TransMilenio.", amenities: "{WiFi,Laundry,Parking,AC}", rules: "{\"No smoking\",\"Quiet after 10 pm\",\"No parties\"}" },
      { title: "Modern Studio Usaquen", property_type: "Studio", rent: 2_100_000, security_deposit: 600_000, lease_term_months: 12, available_date: "2026-07-01", address: "Cra. 6 #119-20", city: "Bogota", state: "Cundinamarca", description: "Brand new studio in Usaquen with access to gym and coworking space. Fiber optic internet.", amenities: "{WiFi,Gym,Laundry,Furnished}", rules: "{\"No smoking\",\"No pets\"}" },
      { title: "Room in Shared Apt Chapinero Alto", property_type: "Shared room", rent: 1_100_000, security_deposit: 300_000, lease_term_months: 6, available_date: "2026-08-01", address: "Cl. 60 #9-15", city: "Bogota", state: "Cundinamarca", description: "Furnished room in a three-person apartment. Great roommates. Close to bars and restaurants.", amenities: "{WiFi,Furnished}", rules: "{\"No smoking\",\"Students only\"}" },
      { title: "Sunny 2BR near Universidad Nacional", property_type: "2 bedrooms", rent: 1_900_000, security_deposit: 500_000, lease_term_months: 12, available_date: "2026-08-01", address: "Cl. 26 #30-10", city: "Bogota", state: "Cundinamarca", description: "Two-bedroom apartment right next to campus. Supermarkets and transport nearby.", amenities: "{WiFi,Laundry,Parking}", rules: "{\"No smoking\",\"No parties\"}" },
      { title: "Luxury 1BR Parque 93", property_type: "1 bedroom", rent: 3_500_000, security_deposit: 1_200_000, lease_term_months: 12, available_date: "2026-07-15", address: "Cl. 93A #13-24", city: "Bogota", state: "Cundinamarca", description: "Premium one-bedroom near Parque 93. Doorman, gym, and underground parking included.", amenities: "{WiFi,AC,Gym,Pool,Parking,Furnished}", rules: "{\"No smoking\",\"No pets\",\"No parties\"}" },
      { title: "Budget Studio near Externado", property_type: "Studio", rent: 1_200_000, security_deposit: 300_000, lease_term_months: 6, available_date: "2026-08-15", address: "Cl. 12 #1-50", city: "Bogota", state: "Cundinamarca", description: "Affordable studio close to Universidad Externado. Basic but clean. Water and gas included.", amenities: "{WiFi}", rules: "{\"No smoking\",\"Quiet after 10 pm\"}" },
      { title: "2BR with Balcony in Cedritos", property_type: "2 bedrooms", rent: 2_000_000, security_deposit: 600_000, lease_term_months: 12, available_date: "2026-09-01", address: "Cl. 140 #13-50", city: "Bogota", state: "Cundinamarca", description: "Two-bedroom apartment with a nice balcony view. Quiet residential neighborhood near parks.", amenities: "{WiFi,Laundry,Balcony,Parking}", rules: "{\"No smoking\"}" },
      { title: "Furnished Room Quinta Camacho", property_type: "Shared room", rent: 1_400_000, security_deposit: 400_000, lease_term_months: 6, available_date: "2026-07-01", address: "Cra. 9 #69-20", city: "Bogota", state: "Cundinamarca", description: "Fully furnished private room in a quiet area. Shared kitchen and bathroom with one other person.", amenities: "{WiFi,Furnished,Laundry}", rules: "{\"No smoking\",\"No overnight guests\"}" },
      { title: "New 1BR near Rosario", property_type: "1 bedroom", rent: 1_700_000, security_deposit: 500_000, lease_term_months: 12, available_date: "2026-08-01", address: "Cl. 14 #6-25", city: "Bogota", state: "Cundinamarca", description: "Recently renovated one-bedroom apartment. Five minutes from Universidad del Rosario.", amenities: "{WiFi,AC,Furnished}", rules: "{\"No smoking\",\"No pets\"}" },
      { title: "3BR House in Chia", property_type: "3+ bedrooms", rent: 3_000_000, security_deposit: 1_000_000, lease_term_months: 12, available_date: "2026-08-15", address: "Cl. 1 #4-60", city: "Chia", state: "Cundinamarca", description: "Spacious house with garden and parking for two cars. Great for a group of students commuting to Bogota.", amenities: "{WiFi,Parking,Laundry,Pool}", rules: "{\"No smoking\",\"No parties\"}" },
      { title: "Compact Studio Galerias", property_type: "Studio", rent: 1_400_000, security_deposit: 400_000, lease_term_months: 6, available_date: "2026-09-01", address: "Cl. 53 #25-40", city: "Bogota", state: "Cundinamarca", description: "Small but efficient studio in the Galerias neighborhood. Close to shops and public transport.", amenities: "{WiFi,Laundry}", rules: "{\"No smoking\",\"Quiet after 10 pm\"}" },
      { title: "2BR near Sabana University", property_type: "2 bedrooms", rent: 1_800_000, security_deposit: 500_000, lease_term_months: 12, available_date: "2026-07-15", address: "Autopista Norte #200-30", city: "Chia", state: "Cundinamarca", description: "Two-bedroom apartment near Universidad de la Sabana. Bus stop right outside the building.", amenities: "{WiFi,Parking,Laundry,Furnished}", rules: "{\"No smoking\",\"Students only\"}" },
      { title: "Artist Loft La Macarena", property_type: "1 bedroom", rent: 2_300_000, security_deposit: 700_000, lease_term_months: 6, available_date: "2026-08-01", address: "Cra. 4A #27-10", city: "Bogota", state: "Cundinamarca", description: "Unique loft space in the bohemian Macarena district. High ceilings, exposed brick, tons of character.", amenities: "{WiFi,Furnished,Balcony}", rules: "{\"No smoking\"}" },
      { title: "Room near Pontificia Javeriana", property_type: "Shared room", rent: 1_250_000, security_deposit: 350_000, lease_term_months: 6, available_date: "2026-08-01", address: "Cra. 7 #43-10", city: "Bogota", state: "Cundinamarca", description: "Private room in a well-maintained apartment. Two blocks from Javeriana campus. All utilities included.", amenities: "{WiFi,Furnished,Laundry}", rules: "{\"No smoking\",\"Students only\",\"Quiet after 10 pm\"}" },
    ]

    now = Time.current
    listings.each do |l|
      execute <<-SQL
        INSERT INTO listings (id, user_id, listing_type, title, description, property_type, address, city, state, rent, security_deposit, lease_term_months, available_date, amenities, rules, status, created_at, updated_at)
        VALUES (
          gen_random_uuid(),
          '#{landlord_id}',
          'property',
          #{ActiveRecord::Base.connection.quote(l[:title])},
          #{ActiveRecord::Base.connection.quote(l[:description])},
          #{ActiveRecord::Base.connection.quote(l[:property_type])},
          #{ActiveRecord::Base.connection.quote(l[:address])},
          #{ActiveRecord::Base.connection.quote(l[:city])},
          #{ActiveRecord::Base.connection.quote(l[:state])},
          #{l[:rent]},
          #{l[:security_deposit]},
          #{l[:lease_term_months]},
          '#{l[:available_date]}',
          '#{l[:amenities]}',
          '#{l[:rules]}',
          'active',
          '#{now.iso8601}',
          '#{now.iso8601}'
        )
      SQL
    end
  end

  def down
    # Remove seeded listings for both possible landlords
    execute "DELETE FROM listings WHERE user_id = 'b53abefe-a5c1-4e6a-ab0b-878ee6e20468'"
    landlord = User.find_by(role: "landlord")
    execute "DELETE FROM listings WHERE user_id = '#{landlord.id}'" if landlord
  end
end
