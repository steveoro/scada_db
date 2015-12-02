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

ActiveRecord::Schema.define(version: 20151202003616) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",              limit: 255, default: "", null: false
    t.string   "encrypted_password", limit: 255, default: "", null: false
    t.string   "description",        limit: 255
    t.integer  "lock_version",       limit: 4,   default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "sign_in_count",      limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip", limit: 255
    t.string   "last_sign_in_ip",    limit: 255
    t.integer  "failed_attempts",    limit: 4,   default: 0,  null: false
    t.string   "unlock_token",       limit: 255
    t.datetime "locked_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "app_parameters", force: :cascade do |t|
    t.integer  "code",         limit: 4
    t.string   "str_1",        limit: 255
    t.string   "str_2",        limit: 255
    t.string   "str_3",        limit: 255
    t.boolean  "bool_1"
    t.boolean  "bool_2"
    t.boolean  "bool_3"
    t.integer  "int_1",        limit: 4
    t.integer  "int_2",        limit: 4
    t.integer  "int_3",        limit: 4
    t.text     "description",  limit: 65535
    t.integer  "lock_version", limit: 4,     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "app_parameters", ["code"], name: "index_app_parameters_on_code", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.text     "notes",        limit: 65535
    t.integer  "lock_version", limit: 4,     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "devices", ["name"], name: "index_devices_on_name", unique: true, using: :btree

  create_table "log_messages", force: :cascade do |t|
    t.integer  "seq",          limit: 8
    t.string   "sender",       limit: 255
    t.string   "receiver",     limit: 255
    t.text     "body",         limit: 65535
    t.integer  "device_id",    limit: 4
    t.integer  "lock_version", limit: 4,     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "log_messages", ["device_id", "sender", "receiver", "seq"], name: "idx_msg_sender_receiver", using: :btree
  add_index "log_messages", ["device_id"], name: "index_log_messages_on_device_id", using: :btree
  add_index "log_messages", ["receiver"], name: "index_log_messages_on_receiver", using: :btree
  add_index "log_messages", ["sender"], name: "index_log_messages_on_sender", using: :btree

  create_table "log_requests", force: :cascade do |t|
    t.integer  "seq",          limit: 8
    t.string   "sender",       limit: 255
    t.string   "receiver",     limit: 255
    t.text     "body",         limit: 65535
    t.integer  "device_id",    limit: 4
    t.integer  "lock_version", limit: 4,     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "log_requests", ["device_id", "sender", "receiver", "seq"], name: "idx_req_sender_receiver", using: :btree
  add_index "log_requests", ["device_id"], name: "index_log_requests_on_device_id", using: :btree
  add_index "log_requests", ["receiver"], name: "index_log_requests_on_receiver", using: :btree
  add_index "log_requests", ["sender"], name: "index_log_requests_on_sender", using: :btree

  create_table "mem_slots", force: :cascade do |t|
    t.string   "msw",          limit: 16
    t.string   "lsw",          limit: 16
    t.string   "format",       limit: 2
    t.text     "description",  limit: 65535
    t.string   "unit",         limit: 8
    t.integer  "decimals",     limit: 2
    t.text     "notes",        limit: 65535
    t.integer  "device_id",    limit: 4
    t.integer  "lock_version", limit: 4,     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "mem_slots", ["device_id", "msw", "lsw", "format"], name: "device_address", unique: true, using: :btree
  add_index "mem_slots", ["device_id"], name: "index_mem_slots_on_device_id", using: :btree
  add_index "mem_slots", ["lsw"], name: "index_mem_slots_on_lsw", using: :btree
  add_index "mem_slots", ["msw"], name: "index_mem_slots_on_msw", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "description",            limit: 255
    t.integer  "lock_version",           limit: 4,   default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "log_messages", "devices"
  add_foreign_key "log_requests", "devices"
  add_foreign_key "mem_slots", "devices"
end
