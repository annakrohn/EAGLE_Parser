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

ActiveRecord::Schema.define(version: 20160329004952) do

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
    t.string   "findRomanProvence"
    t.string   "findAncientSpot"
    t.string   "findModernSpot"
    t.string   "findModernCountry"
    t.string   "findModernRegion"
    t.string   "findModerProvence"
    t.string   "inscriptionType"
    t.string   "objectType"
    t.string   "material"
    t.text     "transcription"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "results", ["queryTerms"], name: "query_key_idx", using: :btree

  create_table "terms", force: true do |t|
    t.string   "query_terms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
