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

ActiveRecord::Schema[7.0].define(version: 2025_12_26_052915) do
  create_table "factions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.string "name"
    t.text "description"
    t.string "color_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["sector_id"], name: "index_factions_on_sector_id"
  end

  create_table "sector_permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "user_id", null: false
    t.boolean "can_view_sector"
    t.boolean "can_edit_sector"
    t.boolean "can_view_factions"
    t.boolean "can_edit_factions"
    t.boolean "can_view_systems"
    t.boolean "can_edit_systems"
    t.boolean "can_view_system_notes"
    t.boolean "can_edit_system_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_id"], name: "index_sector_permissions_on_sector_id"
    t.index ["user_id"], name: "index_sector_permissions_on_user_id"
  end

  create_table "sectors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "author"
    t.binary "public_view"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "hex_color"
    t.integer "border_width"
    t.float "border_opacity"
    t.string "background_image"
    t.boolean "show_grid", default: true
    t.float "grid_opacity", default: 0.1
  end

  create_table "system_notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "sector_id"
    t.integer "system_id"
    t.string "author"
    t.binary "public_view"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
  end

  create_table "system_overrides", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "sector_id"
    t.integer "system_id"
    t.string "property"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "systems", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "Table to hold primary data on systems based on Traveller system and originally generated via random generators like: https://zhodani.space/stuff/generators/random-subsector-generator/ and can be translated into human readable following guidiance here: https://www.traveller-srd.com/core-rules/world-creation/", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.string "name", limit: 45, null: false
    t.string "location", limit: 45, null: false
    t.string "uwp", limit: 9
    t.string "base", limit: 1
    t.string "notes", limit: 45
    t.string "ring", limit: 1
    t.string "pbg", limit: 3
    t.string "allegiance", limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["sector_id"], name: "index_systems_on_sector_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "factions", "sectors"
  add_foreign_key "sector_permissions", "sectors"
  add_foreign_key "sector_permissions", "users"
  add_foreign_key "systems", "sectors"
end
