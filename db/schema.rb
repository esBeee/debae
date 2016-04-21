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

ActiveRecord::Schema.define(version: 20160421025728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "link_to_arguments", force: :cascade do |t|
    t.integer  "statement_id"
    t.integer  "argument_id"
    t.boolean  "is_pro_argument", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "link_to_arguments", ["statement_id", "argument_id"], name: "index_link_to_arguments_on_statement_id_and_argument_id", unique: true, using: :btree
  add_index "link_to_arguments", ["statement_id"], name: "index_link_to_arguments_on_statement_id", using: :btree

  create_table "statements", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "body",       limit: 260, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "statements", ["user_id"], name: "index_statements_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "statement_id"
    t.boolean  "is_pro_vote",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["statement_id"], name: "index_votes_on_statement_id", using: :btree

  add_foreign_key "link_to_arguments", "statements"
  add_foreign_key "statements", "users"
  add_foreign_key "votes", "statements"
  add_foreign_key "votes", "users"
end
