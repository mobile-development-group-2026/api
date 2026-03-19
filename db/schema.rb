# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_19_000009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "lifestyle_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "noise_level"
    t.integer "cleanliness_level"
    t.string "sleep_schedule"
    t.boolean "smoking_allowed", default: false, null: false
    t.boolean "pets_allowed", default: false, null: false
    t.boolean "parties_allowed", default: false, null: false
    t.integer "guest_frequency"
    t.text "lifestyle_tags"
    t.date "move_in_date"
    t.decimal "max_budget", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lifestyle_profiles_on_user_id", unique: true
  end

  create_table "listing_photos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "listing_id", null: false
    t.string "photo_url", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_listing_photos_on_listing_id"
  end

  create_table "listings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "listing_type", null: false
    t.string "title", null: false
    t.text "description"
    t.string "property_type"
    t.string "address", null: false
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.decimal "rent", precision: 10, scale: 2, null: false
    t.decimal "security_deposit", precision: 10, scale: 2
    t.boolean "utilities_included", default: false, null: false
    t.decimal "utilities_cost", precision: 10, scale: 2
    t.date "available_date"
    t.integer "lease_term_months"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.boolean "pets_allowed", default: false, null: false
    t.boolean "parties_allowed", default: false, null: false
    t.boolean "smoking_allowed", default: false, null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_listings_on_latitude_and_longitude"
    t.index ["listing_type"], name: "index_listings_on_listing_type"
    t.index ["rent"], name: "index_listings_on_rent"
    t.index ["status"], name: "index_listings_on_status"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "student_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "university"
    t.string "major"
    t.integer "age"
    t.integer "graduation_year"
    t.index ["user_id"], name: "index_student_profiles_on_user_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "clerk_id", null: false
    t.string "role", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "avatar_url"
    t.text "bio"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_seen_at"
    t.boolean "onboarded", default: false, null: false
    t.index ["clerk_id"], name: "index_users_on_clerk_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "lifestyle_profiles", "users"
  add_foreign_key "listing_photos", "listings"
  add_foreign_key "listings", "users"
  add_foreign_key "student_profiles", "users"
end
