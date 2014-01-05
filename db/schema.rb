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

ActiveRecord::Schema.define(version: 20131215035807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.string   "type"
    t.text     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "actions", ["conversation_id", "created_at"], name: "index_actions_on_conversation_id_and_created_at", using: :btree
  add_index "actions", ["conversation_id"], name: "index_events_on_conversation_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "title"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.datetime "most_recent_event", default: '2000-01-01 01:07:19'
  end

  create_table "conversations_folders", force: true do |t|
    t.integer "conversation_id"
    t.integer "folder_id"
  end

  add_index "conversations_folders", ["conversation_id", "folder_id"], name: "index_conversations_topics_on_conversation_id_and_topic_id", using: :btree
  add_index "conversations_folders", ["folder_id", "conversation_id"], name: "index_conversations_topics_on_topic_id_and_conversation_id", using: :btree

  create_table "email_queues", force: true do |t|
    t.integer  "action_id"
    t.integer  "external_user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "folders", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  add_index "folders", ["email"], name: "index_folders_on_email", using: :btree

  create_table "folders_users", force: true do |t|
    t.integer "folder_id"
    t.integer "user_id"
  end

  add_index "folders_users", ["folder_id", "user_id"], name: "index_topics_users_on_topic_id_and_user_id", using: :btree
  add_index "folders_users", ["user_id", "folder_id"], name: "index_topics_users_on_user_id_and_topic_id", using: :btree

  create_table "group_participations", force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.boolean "group_admin", default: false
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reading_logs", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "most_recent_viewed"
    t.integer  "unread_count",       default: 0
    t.boolean  "archived",           default: false
  end

  add_index "reading_logs", ["conversation_id"], name: "index_reading_logs_on_conversation_id", using: :btree
  add_index "reading_logs", ["user_id", "conversation_id", "most_recent_viewed"], name: "quick_find_most_reent_viewed", using: :btree
  add_index "reading_logs", ["user_id"], name: "index_reading_logs_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                        null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "full_name"
    t.boolean  "site_admin",                   default: false
    t.integer  "invited_by"
    t.integer  "default_folder_id"
    t.boolean  "removed",                      default: false
    t.boolean  "external",                     default: false
    t.boolean  "send_me_mail",                 default: false
  end

  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end
