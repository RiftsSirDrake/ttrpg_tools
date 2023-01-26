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

ActiveRecord::Schema[7.0].define(version: 2023_01_26_174359) do
  create_table "system", primary_key: "location", id: { type: :string, limit: 45 }, charset: "latin1", comment: "Table to hold primary data on systems based on Traveller system and originally generated via random generators like: https://zhodani.space/stuff/generators/random-subsector-generator/ and can be translated into human readable following guidiance here: https://www.traveller-srd.com/core-rules/world-creation/", force: :cascade do |t|
    t.string "name", limit: 45, null: false
    t.string "uwp", limit: 9
    t.string "base", limit: 45
    t.string "notes", limit: 45
    t.string "ring", limit: 1
    t.string "pbg", limit: 3
    t.string "allegiance", limit: 2
  end

  create_table "system_desc", primary_key: "location", id: :integer, default: nil, charset: "latin1", comment: "Table to contain more detailed descriptions of each system, or important notes.", force: :cascade do |t|
    t.string "public_desc", limit: 2000
    t.string "private_desc", limit: 2000
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
