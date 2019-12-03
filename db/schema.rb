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

ActiveRecord::Schema.define(version: 2019_05_28_155048) do

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

  create_table "announces", force: :cascade do |t|
    t.string "text"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.boolean "read_flag", default: false
    t.boolean "favor_flag", default: false
    t.boolean "muted", default: false
    t.bigint "from_user_id"
    t.string "from_addr"
    t.bigint "to_note_id"
    t.bigint "response_id"
    t.integer "anonimity", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["from_user_id"], name: "index_comments_on_from_user_id"
    t.index ["response_id"], name: "index_comments_on_response_id"
    t.index ["to_note_id"], name: "index_comments_on_to_note_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "user_id"
    t.string "endpoint"
    t.string "p256dh"
    t.string "auth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "type"
    t.integer "stage", default: 2
    t.string "thumb_info"
    t.string "tags"
    t.integer "comment_receive_stance", default: 10
    t.integer "comment_share_stance", default: 0
    t.bigint "user_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "view_stance", default: 10
    t.boolean "shared_to_public", default: true
    t.integer "rating", default: 0
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "text"
    t.string "type"
    t.float "order"
    t.bigint "note_id"
    t.datetime "deleted_at"
    t.string "twitter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_at"
    t.integer "status"
    t.datetime "finished_at"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["note_id"], name: "index_posts_on_note_id"
  end

  create_table "shinchoku_dodeskas", force: :cascade do |t|
    t.bigint "from_user_id"
    t.string "from_addr"
    t.bigint "to_note_id"
    t.integer "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_shinchoku_dodeskas_on_from_user_id"
    t.index ["to_note_id"], name: "index_shinchoku_dodeskas_on_to_note_id"
  end

  create_table "user_blocks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "blocking_user_id"
    t.string "blocking_addr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "blocking_comment_id"
    t.index ["blocking_comment_id"], name: "index_user_blocks_on_blocking_comment_id"
    t.index ["blocking_user_id"], name: "index_user_blocks_on_blocking_user_id"
    t.index ["user_id"], name: "index_user_blocks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "twitter_id"
    t.string "name"
    t.string "screen_name"
    t.string "url"
    t.string "thumb_url"
    t.string "desc"
    t.string "user_group_info"
    t.string "permission", default: ""
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "checked_notifications_at"
    t.binary "linked_users_info"
    t.datetime "saw_notifications_at"
    t.boolean "comment_webpush_enabled", default: true
    t.boolean "shinchoku_dodeska_webpush_enabled", default: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["twitter_id"], name: "index_users_on_twitter_id", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.bigint "from_user_id"
    t.bigint "to_note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_watchlists_on_from_user_id"
    t.index ["to_note_id"], name: "index_watchlists_on_to_note_id"
  end

  add_foreign_key "comments", "notes", column: "to_note_id"
  add_foreign_key "comments", "posts", column: "response_id"
  add_foreign_key "comments", "users", column: "from_user_id"
  add_foreign_key "notes", "users"
  add_foreign_key "posts", "notes"
  add_foreign_key "shinchoku_dodeskas", "notes", column: "to_note_id"
  add_foreign_key "shinchoku_dodeskas", "users", column: "from_user_id"
  add_foreign_key "user_blocks", "comments", column: "blocking_comment_id"
  add_foreign_key "user_blocks", "users"
  add_foreign_key "user_blocks", "users", column: "blocking_user_id"
  add_foreign_key "watchlists", "notes", column: "to_note_id"
  add_foreign_key "watchlists", "users", column: "from_user_id"
end
