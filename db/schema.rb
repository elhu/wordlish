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

ActiveRecord::Schema.define(version: 2022_01_20_173929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "game_status", ["ongoing", "done"]
  create_enum "word_status", ["not_started", "ongoing", "done"]

  create_table "attempts", force: :cascade do |t|
    t.string "guess", null: false
    t.bigint "word_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", null: false
    t.index ["word_id"], name: "index_attempts_on_word_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "score", default: 0, null: false
    t.enum "status", default: "ongoing", null: false, enum_type: "game_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_words", default: 25, null: false
    t.integer "max_attempts", default: 6, null: false
    t.integer "word_length", default: 5, null: false
    t.string "seed", null: false
    t.index ["score"], name: "index_games_on_score"
    t.index ["uuid"], name: "index_games_on_uuid", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string "to_guess"
    t.integer "score", default: 0, null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "status", default: "not_started", null: false, enum_type: "word_status"
    t.integer "position", null: false
    t.index ["game_id"], name: "index_words_on_game_id"
  end

  add_foreign_key "attempts", "words"
  add_foreign_key "words", "games"
end
