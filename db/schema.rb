# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160722160934) do

  create_table "chart_entries", force: :cascade do |t|
    t.integer  "position",   null: false
    t.integer  "chart_id",   null: false
    t.integer  "track_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chart_entries", ["chart_id"], name: "index_chart_entries_on_chart_id"
  add_index "chart_entries", ["position", "chart_id"], name: "index_chart_entries_on_position_and_chart_id", unique: true
  add_index "chart_entries", ["position"], name: "index_chart_entries_on_position"
  add_index "chart_entries", ["track_id"], name: "index_chart_entries_on_track_id"

  create_table "charts", force: :cascade do |t|
    t.date     "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "artist"
    t.string   "title"
    t.string   "image_url"
    t.string   "record_id"
    t.integer  "rebox_id"
    t.string   "ilm_isrc"
    t.string   "ilm_id"
    t.string   "ilm_genre"
    t.string   "ilm_year"
    t.string   "ilm_tunecode"
    t.string   "ilm_iswc"
    t.integer  "ilm_duration"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "explicit"
    t.string   "occ_product_id"
    t.string   "occ_image_url"
    t.string   "label"
    t.string   "wave_file_id"
  end

end
