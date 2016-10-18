# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161017221007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_events", force: :cascade do |t|
    t.string  "description"
    t.string  "half"
    t.integer "inning"
    t.integer "mlb_game_id"
    t.index ["mlb_game_id"], name: "index_game_events_on_mlb_game_id", using: :btree
  end

  create_table "mlb_games", force: :cascade do |t|
    t.string  "game_id"
    t.string  "game_type"
    t.integer "home_id"
    t.integer "away_id"
    t.index ["away_id"], name: "index_mlb_games_on_away_id", using: :btree
    t.index ["home_id"], name: "index_mlb_games_on_home_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "game_events", "mlb_games"
end
