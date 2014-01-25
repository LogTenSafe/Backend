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

ActiveRecord::Schema.define(version: 20140124090533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backups", force: true do |t|
    t.integer  "user_id",                                                  null: false
    t.string   "logbook_file_name",                                        null: false
    t.string   "logbook_content_type",                                     null: false
    t.string   "logbook_fingerprint",                                      null: false
    t.integer  "logbook_file_size",                                        null: false
    t.datetime "logbook_updated_at",                                       null: false
    t.date     "last_flight_date"
    t.text     "last_flight"
    t.decimal  "total_hours",                      precision: 7, scale: 1, null: false
    t.string   "hostname",             limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "backups", ["user_id", "created_at"], name: "index_backups_on_user_id_and_created_at", using: :btree
  add_index "backups", ["user_id", "last_flight_date"], name: "index_backups_on_user_id_and_last_flight_date", using: :btree
  add_index "backups", ["user_id", "logbook_fingerprint"], name: "index_backups_on_user_id_and_logbook_fingerprint", unique: true, using: :btree
  add_index "backups", ["user_id", "total_hours"], name: "index_backups_on_user_id_and_total_hours", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",            limit: 128, null: false
    t.string   "crypted_password", limit: 128, null: false
    t.string   "pepper",           limit: 128, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
