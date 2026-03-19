puts "Seeding database..."

# Create a dev student
student = User.find_or_create_by!(clerk_id: "dev_student_1") do |u|
  u.role = "student"
  u.first_name = "Maria"
  u.last_name = "Garcia"
  u.email = "maria@university.edu"
  u.phone = "+1234567890"
  u.university = "MIT"
  u.verified = true
end

# Create student profile
student.create_student_profile!(
  date_of_birth: Date.new(2003, 5, 15),
  gender: "female",
  academic_level: "undergrad",
  budget_min: 400,
  budget_max: 900,
  move_in_date: Date.new(2026, 8, 1),
  noise_level: 2,
  cleanliness: 4,
  guests_policy: 3,
  daily_routine: "early_bird",
  pets_ok: false,
  smoking_ok: false
) unless student.student_profile

# Create a dev landlord
landlord = User.find_or_create_by!(clerk_id: "dev_landlord_1") do |u|
  u.role = "landlord"
  u.first_name = "John"
  u.last_name = "Smith"
  u.email = "john@realty.com"
  u.phone = "+0987654321"
  u.verified = true
end

# Create sample listings for the landlord
listing1 = Listing.find_or_create_by!(title: "Sunny 2BR near Campus", user: landlord) do |l|
  l.listing_type = "property"
  l.description = "Beautiful 2-bedroom apartment, 5 min walk from campus. Recently renovated with modern kitchen."
  l.property_type = "apartment"
  l.address = "123 University Ave"
  l.city = "Cambridge"
  l.state = "MA"
  l.zip_code = "02139"
  l.latitude = 42.3736
  l.longitude = -71.1097
  l.rent = 1800.00
  l.security_deposit = 1800.00
  l.utilities_included = false
  l.utilities_cost = 150.00
  l.available_date = Date.new(2026, 8, 1)
  l.lease_term_months = 12
  l.bedrooms = 2
  l.bathrooms = 1
  l.pets_allowed = false
  l.parties_allowed = false
  l.smoking_allowed = false
end

listing2 = Listing.find_or_create_by!(title: "Cozy Studio Downtown", user: landlord) do |l|
  l.listing_type = "property"
  l.description = "Compact studio perfect for a single student. All utilities included. Laundry in building."
  l.property_type = "studio"
  l.address = "456 Main St"
  l.city = "Cambridge"
  l.state = "MA"
  l.zip_code = "02142"
  l.latitude = 42.3625
  l.longitude = -71.0862
  l.rent = 1200.00
  l.security_deposit = 1200.00
  l.utilities_included = true
  l.available_date = Date.new(2026, 7, 15)
  l.lease_term_months = 12
  l.bedrooms = 0
  l.bathrooms = 1
  l.pets_allowed = true
  l.smoking_allowed = false
end

# Create a room listing from the student
Listing.find_or_create_by!(title: "Room in 3BR Shared Apt", user: student) do |l|
  l.listing_type = "room"
  l.description = "Looking for a roommate! Shared 3BR apartment. Your room is furnished. Common areas shared."
  l.property_type = "room"
  l.address = "789 College St"
  l.city = "Cambridge"
  l.state = "MA"
  l.zip_code = "02140"
  l.latitude = 42.3880
  l.longitude = -71.1280
  l.rent = 650.00
  l.security_deposit = 650.00
  l.utilities_included = true
  l.available_date = Date.new(2026, 9, 1)
  l.lease_term_months = 10
  l.bedrooms = 1
  l.bathrooms = 1
  l.pets_allowed = false
  l.parties_allowed = false
  l.smoking_allowed = false
end

puts "Seeded: #{User.count} users, #{StudentProfile.count} student profiles, #{Listing.count} listings"
puts ""
puts "Dev users for Bruno testing (use X-Dev-Clerk-Id header):"
puts "  Student: dev_student_1"
puts "  Landlord: dev_landlord_1"
