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

ActiveRecord::Schema.define(version: 20160401044357) do

  create_table "blogs", force: :cascade do |t|
    t.text     "name"
    t.date     "date_created"
    t.text     "content"
    t.text     "tags"
    t.integer  "subject_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "blogs", ["subject_id"], name: "index_blogs_on_subject_id"

  create_table "daily_messages", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hits", force: :cascade do |t|
    t.text     "page"
    t.date     "date_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "service_dailies", force: :cascade do |t|
    t.text     "key_words"
    t.text     "sender"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "adv",            default: 0
    t.integer  "anti",           default: 0
    t.text     "adv_keys"
    t.text     "adv_keywords"
    t.text     "adv_antiwords"
    t.text     "adv_senders"
    t.text     "adv_categories"
  end

  create_table "subjects", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "email"
    t.text     "password_digest"
    t.integer  "ryan"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
