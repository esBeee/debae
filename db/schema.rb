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

ActiveRecord::Schema.define(version: 20170907140845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body", null: false
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "statement_argument_links", id: :serial, force: :cascade do |t|
    t.integer "statement_id"
    t.integer "argument_id"
    t.boolean "is_pro_argument", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["argument_id"], name: "index_statement_argument_links_on_argument_id"
    t.index ["statement_id", "argument_id"], name: "index_statement_argument_links_on_statement_id_and_argument_id", unique: true
    t.index ["statement_id"], name: "index_statement_argument_links_on_statement_id"
  end

  create_table "statements", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.jsonb "body", default: "{}", null: false
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "top_level", default: false, null: false
    t.decimal "argument_score"
    t.decimal "vote_score"
    t.integer "amount_of_votes"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 70, default: "", null: false
    t.boolean "email_if_new_argument", default: true, null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.jsonb "uids", default: "{}", null: false
    t.string "link_to_facebook", limit: 500
    t.string "link_to_twitter", limit: 500
    t.string "link_to_google_plus", limit: 500
    t.index "((uids ->> 'facebook'::text))", name: "facebook_uid_index", unique: true
    t.index "((uids ->> 'google_oauth2'::text))", name: "google_oauth2_uid_index", unique: true
    t.index "((uids ->> 'twitter'::text))", name: "twitter_uid_index", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "voteable_type"
    t.integer "voteable_id"
    t.boolean "is_pro_vote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "voteable_id", "voteable_type"], name: "index_votes_on_user_id_and_voteable_id_and_voteable_type", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["voteable_type", "voteable_id"], name: "index_votes_on_voteable_type_and_voteable_id"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "statement_argument_links", "statements"
  add_foreign_key "statement_argument_links", "statements", column: "argument_id"
  add_foreign_key "statements", "users"
  add_foreign_key "votes", "users"
end
