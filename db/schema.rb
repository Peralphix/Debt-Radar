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

ActiveRecord::Schema[7.2].define(version: 2026_02_09_062354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "inn", null: false
    t.date "birthdate"
    t.jsonb "kad_arbitr_raw_data"
    t.jsonb "kad_arbitr_parsed_data"
    t.jsonb "bankrot_raw_data"
    t.jsonb "bankrot_parsed_data"
    t.jsonb "nalog_raw_data"
    t.jsonb "nalog_parsed_data"
    t.datetime "kad_arbitr_updated_at"
    t.datetime "bankrot_updated_at"
    t.datetime "nalog_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn"], name: "index_users_on_inn", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "vin"
    t.string "sts_number"
    t.string "registration_number"
    t.jsonb "zalog_raw_data"
    t.jsonb "zalog_parsed_data"
    t.jsonb "traffic_fines_raw_data"
    t.jsonb "traffic_fines_parsed_data"
    t.datetime "zalog_updated_at"
    t.datetime "traffic_fines_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_number"], name: "index_vehicles_on_registration_number", unique: true
    t.index ["sts_number"], name: "index_vehicles_on_sts_number", unique: true
    t.index ["user_id"], name: "index_vehicles_on_user_id"
    t.index ["vin"], name: "index_vehicles_on_vin", unique: true
  end

  add_foreign_key "vehicles", "users"
end
