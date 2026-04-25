class AddTestListingsForLandlord < ActiveRecord::Migration[8.0]
  def up
    target_user_id = '295db6ff-4228-4e6f-ab27-8178a5406a4a'

    listings = [
      {
        title: 'Apartaestudio City U', description: 'Vista panorámica, amoblado ideal para estudiante de Uniandes. Seguridad 24 hrs.',
        listing_type: 'property', property_type: 'studio', address: 'Calle 19 # 2-49', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110321',
        latitude: 4.6045, longitude: -74.0682, rent: 1800000.0, security_deposit: 1800000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-01',
        lease_term_months: 6, bedrooms: 0, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'gym', 'coworking', 'security'], rules: ['no smoking', 'no loud music after 11pm'], views_count: 15
      },
      {
        title: 'Habitación amplia en Las Aguas', description: 'A 5 minutos del bloque Mario Laserna. Se comparte baño con una persona.',
        listing_type: 'property', property_type: 'room', address: 'Carrera 3 # 18-45', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110321',
        latitude: 4.6021, longitude: -74.0665, rent: 950000.0, security_deposit: 500000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-15',
        lease_term_months: 12, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'laundry', 'kitchen access'], rules: ['clean common areas', 'no overnight guests'], views_count: 42
      },
      {
        title: 'Apartamento de 2 cuartos en La Macarena', description: 'Excelente zona gastronómica y cultural. Bien iluminado.',
        listing_type: 'property', property_type: 'apartment', address: 'Carrera 4 # 26-30', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110311',
        latitude: 4.6133, longitude: -74.0669, rent: 2200000.0, security_deposit: 2200000.0,
        utilities_included: false, utilities_cost: 150000.0, available_date: '2026-06-01',
        lease_term_months: 12, bedrooms: 2, bathrooms: 2, pets_allowed: true, parties_allowed: true, smoking_allowed: false, status: 'active',
        amenities: ['balcony', 'pet friendly', 'washer'], rules: [], views_count: 8
      },
      {
        title: 'Cuarto en Teusaquillo, casa patrimonial', description: 'Casa grande de estudiantes, ambiente tranquilo. Cerca al Parkway.',
        listing_type: 'property', property_type: 'room', address: 'Calle 39 # 14-20', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111311',
        latitude: 4.6278, longitude: -74.0721, rent: 850000.0, security_deposit: 850000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-04-30',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: true, parties_allowed: false, smoking_allowed: true, status: 'active',
        amenities: ['backyard', 'wifi', 'bike parking'], rules: ['respect quiet hours'], views_count: 102
      },
      {
        title: 'Apartaestudio moderno en Chapinero Alto', description: 'Edificio inteligente, zona muy segura y con acceso a transporte.',
        listing_type: 'property', property_type: 'studio', address: 'Carrera 5 # 59-10', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110231',
        latitude: 4.6461, longitude: -74.0592, rent: 1950000.0, security_deposit: 1950000.0,
        utilities_included: false, utilities_cost: 180000.0, available_date: '2026-05-01',
        lease_term_months: 12, bedrooms: 0, bathrooms: 1, pets_allowed: true, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['gym', 'rooftop', 'bbq', 'security'], rules: ['no smoking'], views_count: 23
      },
      {
        title: 'Habitación económica Centro Internacional', description: 'Ideal para estudiantes que buscan centralidad y buen precio.',
        listing_type: 'property', property_type: 'room', address: 'Carrera 13 # 28-38', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110311',
        latitude: 4.6152, longitude: -74.0700, rent: 750000.0, security_deposit: 300000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-04-26',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'elevator'], rules: ['no pets', 'no parties'], views_count: 5
      },
      {
        title: 'Apartamento amoblado cerca a la Nacional', description: 'Acogedor, con escritorio y silla ergonómica.',
        listing_type: 'property', property_type: 'apartment', address: 'Calle 45 # 30-10', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111321',
        latitude: 4.6385, longitude: -74.0811, rent: 1600000.0, security_deposit: 1600000.0,
        utilities_included: false, utilities_cost: 120000.0, available_date: '2026-07-01',
        lease_term_months: 12, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: true, smoking_allowed: false, status: 'active',
        amenities: ['furnished', 'wifi', 'tv'], rules: [], views_count: 56
      },
      {
        title: 'Habitación premium en Rosales', description: 'En zona exclusiva, acceso a club house del edificio.',
        listing_type: 'property', property_type: 'room', address: 'Carrera 4 # 72-15', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110221',
        latitude: 4.6552, longitude: -74.0531, rent: 1300000.0, security_deposit: 1300000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-10',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: true, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['pool', 'gym', 'wifi'], rules: ['no smoking indoors'], views_count: 11
      },
      {
        title: 'Loft industrial Quinta Camacho', description: 'Diseño moderno, pared de ladrillo, muy cerca de zonas de estudio.',
        listing_type: 'property', property_type: 'studio', address: 'Calle 70 # 10-22', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110221',
        latitude: 4.6568, longitude: -74.0601, rent: 2100000.0, security_deposit: 2000000.0,
        utilities_included: false, utilities_cost: 200000.0, available_date: '2026-05-05',
        lease_term_months: 12, bedrooms: 0, bathrooms: 1, pets_allowed: true, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'parking', 'laundry'], rules: ['pet deposit required'], views_count: 34
      },
      {
        title: 'Habitación compartida La Candelaria', description: 'Opción súper económica, se comparte cuarto con estudiante de ingeniería.',
        listing_type: 'property', property_type: 'room', address: 'Calle 11 # 2-30', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111711',
        latitude: 4.5961, longitude: -74.0722, rent: 450000.0, security_deposit: 200000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-04-28',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi'], rules: ['clean daily', 'no guests'], views_count: 89
      },
      {
        title: 'Apartamento de 3 cuartos Galerías', description: 'Perfecto para arrendar entre 3 roomies. Cerca a CC Galerías.',
        listing_type: 'property', property_type: 'apartment', address: 'Carrera 24 # 53-15', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111311',
        latitude: 4.6412, longitude: -74.0755, rent: 3000000.0, security_deposit: 3000000.0,
        utilities_included: false, utilities_cost: 250000.0, available_date: '2026-06-15',
        lease_term_months: 12, bedrooms: 3, bathrooms: 2, pets_allowed: true, parties_allowed: true, smoking_allowed: true, status: 'active',
        amenities: ['parking', 'balcony'], rules: [], views_count: 4
      },
      {
        title: 'Apartaestudio con balcón en Marly', description: 'Excelente luz en la mañana, edificio con lavandería comunal.',
        listing_type: 'property', property_type: 'studio', address: 'Calle 50 # 8-40', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110231',
        latitude: 4.6355, longitude: -74.0622, rent: 1750000.0, security_deposit: 1500000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-20',
        lease_term_months: 12, bedrooms: 0, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['balcony', 'wifi', 'laundry'], rules: ['no pets'], views_count: 17
      },
      {
        title: 'Habitación en apartamento familiar Parkway', description: 'Familia arrienda cuarto a estudiante serio. Alimentación opcional.',
        listing_type: 'property', property_type: 'room', address: 'Carrera 24 # 37-50', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111311',
        latitude: 4.6251, longitude: -74.0755, rent: 700000.0, security_deposit: 350000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-04-25',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'meals optional'], rules: ['no guests after 9pm', 'quiet hours'], views_count: 3
      },
      {
        title: 'Apartamento moderno Chico Sur', description: 'Cerca a Transmilenio y zona T, ideal para moverse por toda la ciudad.',
        listing_type: 'property', property_type: 'apartment', address: 'Calle 90 # 15-20', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110221',
        latitude: 4.6721, longitude: -74.0533, rent: 2800000.0, security_deposit: 2800000.0,
        utilities_included: false, utilities_cost: 220000.0, available_date: '2026-05-01',
        lease_term_months: 12, bedrooms: 2, bathrooms: 2, pets_allowed: true, parties_allowed: true, smoking_allowed: false, status: 'active',
        amenities: ['parking', 'gym', 'security'], rules: ['register all guests'], views_count: 67
      },
      {
        title: 'Apartaestudio silencioso Bosque Izquierdo', description: 'Tranquilidad total en pleno centro de la ciudad.',
        listing_type: 'property', property_type: 'studio', address: 'Carrera 3 # 25-10', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110311',
        latitude: 4.6112, longitude: -74.0655, rent: 1850000.0, security_deposit: 1850000.0,
        utilities_included: false, utilities_cost: 150000.0, available_date: '2026-06-01',
        lease_term_months: 12, bedrooms: 0, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'view'], rules: ['no parties'], views_count: 22
      },
      {
        title: 'Cuarto con baño privado Chapinero Central', description: 'Independencia total, entrada compartida pero baño propio.',
        listing_type: 'property', property_type: 'room', address: 'Calle 60 # 13-25', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110231',
        latitude: 4.6478, longitude: -74.0622, rent: 1100000.0, security_deposit: 1100000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-05',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: true, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['private bathroom', 'wifi'], rules: ['clean own space'], views_count: 45
      },
      {
        title: 'Mini estudio económico en San Diego', description: 'Pequeño pero funcional. A dos pasos de la 7ma.',
        listing_type: 'property', property_type: 'studio', address: 'Carrera 7 # 26-10', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110311',
        latitude: 4.6144, longitude: -74.0691, rent: 1400000.0, security_deposit: 1400000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-04-30',
        lease_term_months: 6, bedrooms: 0, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'security'], rules: [], views_count: 12
      },
      {
        title: 'Apartamento Duplex Usaquén', description: 'Para presupuestos más altos. Acabados de lujo.',
        listing_type: 'property', property_type: 'apartment', address: 'Calle 116 # 6-20', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110111',
        latitude: 4.6951, longitude: -74.0322, rent: 4500000.0, security_deposit: 4500000.0,
        utilities_included: false, utilities_cost: 350000.0, available_date: '2026-05-15',
        lease_term_months: 12, bedrooms: 2, bathrooms: 3, pets_allowed: true, parties_allowed: true, smoking_allowed: false, status: 'active',
        amenities: ['parking', 'rooftop', 'gym', 'fireplace'], rules: ['no smoking'], views_count: 78
      },
      {
        title: 'Habitación luminosa en Palermo', description: 'Barrio residencial y tranquilo, excelente para estudiar.',
        listing_type: 'property', property_type: 'room', address: 'Calle 47 # 16-20', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '111311',
        latitude: 4.6355, longitude: -74.0711, rent: 880000.0, security_deposit: 880000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-05-01',
        lease_term_months: 6, bedrooms: 1, bathrooms: 1, pets_allowed: false, parties_allowed: false, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'laundry'], rules: ['no pets'], views_count: 29
      },
      {
        title: 'Apartaestudio loft cerca a zona universitaria', description: 'Espacio abierto, cocina integral y clóset amplio.',
        listing_type: 'property', property_type: 'studio', address: 'Carrera 1 # 20-30', city: 'Bogotá', state: 'Bogotá D.C.', zip_code: '110321',
        latitude: 4.6051, longitude: -74.0666, rent: 1700000.0, security_deposit: 1700000.0,
        utilities_included: true, utilities_cost: nil, available_date: '2026-06-01',
        lease_term_months: 12, bedrooms: 0, bathrooms: 1, pets_allowed: true, parties_allowed: true, smoking_allowed: false, status: 'active',
        amenities: ['wifi', 'security', 'bike parking'], rules: [], views_count: 51
      }
    ]

    listings.each do |listing_attrs|
      Listing.create!(
        listing_attrs.merge(user_id: target_user_id)
      )
    end
    
    puts "✅ Successfully inserted 20 Romora listings for user: #{target_user_id}."
  end

  def down
    target_user_id = '295db6ff-4228-4e6f-ab27-8178a5406a4a'
    count = Listing.where(user_id: target_user_id).delete_all
    puts "🗑️ Rolled back: Deleted #{count} listings for user: #{target_user_id}."
  end
end