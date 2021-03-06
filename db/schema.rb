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

ActiveRecord::Schema.define(version: 20160412033430) do

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "modern"
  end

  create_table "results", force: true do |t|
    t.integer  "queryTerms"
    t.string   "title"
    t.string   "entityType"
    t.string   "source"
    t.string   "sourceUrl"
    t.string   "tmId"
    t.integer  "notBeforeDate"
    t.integer  "notAfterDate"
    t.string   "period"
    t.integer  "findRomanProvence"
    t.integer  "findAncientSpot"
    t.integer  "findModernSpot"
    t.integer  "findModernCountry"
    t.integer  "findModernRegion"
    t.integer  "findModernProvence"
    t.string   "inscriptionType"
    t.string   "objectType"
    t.string   "material"
    t.text     "transcription",      limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",        limit: 2147483647
    t.text     "cleanTranscription", limit: 2147483647
  end

  add_index "results", ["findAncientSpot"], name: "a_spot_idx", using: :btree
  add_index "results", ["findModernCountry"], name: "m_country_idx", using: :btree
  add_index "results", ["findModernProvence"], name: "m_provence_idx", using: :btree
  add_index "results", ["findModernRegion"], name: "m_region_idx", using: :btree
  add_index "results", ["findModernSpot"], name: "m_spot_idx", using: :btree
  add_index "results", ["findRomanProvence"], name: "r_prov_idx", using: :btree
  add_index "results", ["queryTerms"], name: "query_key_idx", using: :btree

  create_table "terms", force: true do |t|
    t.text     "query_terms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
