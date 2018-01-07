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

ActiveRecord::Schema.define(version: 4) do

  create_table "coins", force: :cascade do |t|
    t.string "symbol"
    t.string "url"
    t.index ["symbol"], name: "index_coins_on_symbol", unique: true
  end

  create_table "index_coins", force: :cascade do |t|
    t.string "symbol"
    t.decimal "weight"
    t.integer "index_id"
    t.integer "coin_id"
    t.index ["coin_id"], name: "index_index_coins_on_coin_id"
    t.index ["index_id", "coin_id"], name: "index_index_coins_on_index_id_and_coin_id", unique: true
    t.index ["index_id"], name: "index_index_coins_on_index_id"
  end

  create_table "indices", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.index ["name"], name: "index_indices_on_name", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.string "symbol"
    t.date "date"
    t.decimal "open"
    t.decimal "high"
    t.decimal "low"
    t.decimal "close"
    t.decimal "volume"
    t.decimal "market_cap"
    t.integer "coin_id"
    t.index ["coin_id", "date"], name: "index_prices_on_coin_id_and_date", unique: true
    t.index ["coin_id"], name: "index_prices_on_coin_id"
  end

end
