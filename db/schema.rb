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

ActiveRecord::Schema.define(version: 2018_10_01_104116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "conversation_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.boolean "is_creator", default: false
    t.boolean "is_read", default: false
    t.boolean "is_archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archive_number"
    t.datetime "archived_at"
    t.index ["conversation_id"], name: "index_conversation_users_on_conversation_id"
    t.index ["user_id"], name: "index_conversation_users_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "title"
    t.string "absolute_url"
    t.boolean "is_archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.text "message"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.string "message_type"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "attachment"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "readers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_readers_on_message_id"
    t.index ["user_id"], name: "index_readers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "uuid"
    t.string "email"
    t.string "absolute_url"
    t.string "avatar"
    t.string "avatar_thumbnail"
    t.string "cover"
    t.string "cover_cropped"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.text "access_token"
    t.string "expires_in"
    t.datetime "token_created_at"
  end

  add_foreign_key "conversation_users", "conversations"
  add_foreign_key "conversation_users", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "readers", "messages"
  add_foreign_key "readers", "users"
end
