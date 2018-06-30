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

ActiveRecord::Schema.define(version: 2018_06_30_125139) do

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
    t.integer "from_user_id"
    t.string "from_addr"
    t.integer "to_note_id"
    t.integer "response_id"
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
    t.integer "user_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "view_stance", default: 10
    t.boolean "shared_to_public", default: true
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "text"
    t.string "type"
    t.float "order"
    t.integer "note_id"
    t.datetime "deleted_at"
    t.string "twitter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_at"
    t.integer "status"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["note_id"], name: "index_posts_on_note_id"
  end

  create_table "shinchoku_dodeskas", force: :cascade do |t|
    t.integer "from_user_id"
    t.string "from_addr"
    t.integer "to_note_id"
    t.integer "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_shinchoku_dodeskas_on_from_user_id"
    t.index ["to_note_id"], name: "index_shinchoku_dodeskas_on_to_note_id"
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
    t.boolean "comment_webpush_enabled"
    t.boolean "shinchoku_dodeska_webpush_enabled"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["twitter_id"], name: "index_users_on_twitter_id", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_watchlists_on_from_user_id"
    t.index ["to_note_id"], name: "index_watchlists_on_to_note_id"
  end

end
