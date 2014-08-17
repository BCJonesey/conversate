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


ActiveRecord::Schema.define(version: 20140810180823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.string   "type"
    t.json     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.tsvector "search_vector"
  end

  add_index "actions", ["conversation_id", "created_at"], name: "index_actions_on_conversation_id_and_created_at", using: :btree
  add_index "actions", ["conversation_id"], name: "index_actions_on_conversation_id", using: :btree
  add_index "actions", ["search_vector"], name: "index_actions_on_search_vector", using: :gin

  create_table "beta_signups", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_lists", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "contact_list_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "conversations_folders", ["conversation_id", "folder_id"], name: "index_conversations_folders_on_conversation_id_and_folder_id", using: :btree
  add_index "conversations_folders", ["folder_id", "conversation_id"], name: "index_conversations_folders_on_folder_id_and_conversation_id", using: :btree

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

  add_index "folders_users", ["folder_id", "user_id"], name: "index_folders_users_on_folder_id_and_user_id", using: :btree
  add_index "folders_users", ["user_id", "folder_id"], name: "index_folders_users_on_user_id_and_folder_id", using: :btree

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

  create_table "participants", force: true do |t|
    t.integer  "participatable_id"
    t.string   "participatable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inviter_id"
  end

  create_table "reading_logs", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "most_recent_viewed"
    t.integer  "unread_count",       default: 0
    t.boolean  "archived",           default: false
    t.boolean  "pinned",             default: false
  end

  add_index "reading_logs", ["conversation_id"], name: "index_reading_logs_on_conversation_id", using: :btree
  add_index "reading_logs", ["user_id", "conversation_id", "most_recent_viewed"], name: "quick_find_most_reent_viewed", using: :btree
  add_index "reading_logs", ["user_id"], name: "index_reading_logs_on_user_id", using: :btree

  create_table "uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "full_name"
    t.boolean  "site_admin",                      default: false
    t.integer  "default_folder_id"
    t.boolean  "removed",                         default: false
    t.boolean  "external",                        default: false
    t.boolean  "send_me_mail",                    default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "default_contact_list_id"
    t.integer  "invite_count",                    default: 0
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "creation_source",                 default: "web"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
