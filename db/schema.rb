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

ActiveRecord::Schema.define(version: 20140422032954) do

  create_table "addresses", force: true do |t|
    t.integer  "card_id"
    t.string   "name"
    t.string   "address"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone1"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  create_table "cards", force: true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "dob"
    t.string   "em_contact"
    t.string   "doctor"
    t.string   "insurance"
    t.string   "insur_numner"
    t.string   "medical_history1"
    t.string   "medical_history2"
    t.string   "medical_history3"
    t.string   "medical_history4"
    t.string   "medical_history5"
    t.string   "medication1"
    t.string   "medication2"
    t.string   "medication3"
    t.string   "medication4"
    t.string   "medication5"
    t.boolean  "pvc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.string   "phone1"
    t.string   "phone_doc"
    t.string   "phone_em"
    t.string   "phone_insur"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "bloodtype"
  end

end
