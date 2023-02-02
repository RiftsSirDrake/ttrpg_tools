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

ActiveRecord::Schema[7.0].define(version: 2023_02_01_165134) do
  create_table "sectors", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "author"
    t.binary "public_view"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_notes", charset: "latin1", force: :cascade do |t|
    t.integer "sector_id"
    t.integer "system_id"
    t.string "author"
    t.binary "public_view"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_overrides", charset: "latin1", force: :cascade do |t|
    t.integer "sector_id"
    t.integer "system_id"
    t.string "property"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "systems", charset: "latin1", comment: "Table to hold primary data on systems based on Traveller system and originally generated via random generators like: https://zhodani.space/stuff/generators/random-subsector-generator/ and can be translated into human readable following guidiance here: https://www.traveller-srd.com/core-rules/world-creation/", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.string "name", limit: 45, null: false
    t.string "location", limit: 45, null: false
    t.string "uwp", limit: 9
    t.string "base", limit: 1
    t.string "notes", limit: 45
    t.string "ring", limit: 1
    t.string "pbg", limit: 3
    t.string "allegiance", limit: 45
    t.index ["sector_id"], name: "index_systems_on_sector_id"
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "systems", "sectors"
end
