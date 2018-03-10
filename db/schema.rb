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

ActiveRecord::Schema.define(version: 20180303153542) do

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.boolean "is_read"
    t.integer "from_user_id"
    t.string "from_addr"
    t.integer "to_note_id"
    t.integer "response_id"
    t.string "anonimity", default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_comments_on_from_user_id"
    t.index ["response_id"], name: "index_comments_on_response_id"
    t.index ["to_note_id"], name: "index_comments_on_to_note_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "type"
    t.string "thumb_info"
    t.string "tags"
    t.integer "comment_receive_stance", default: 10
    t.integer "comment_share_stance", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "text"
    t.string "type"
    t.float "order"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitter_id"
    t.string "media_urls"
    t.index ["note_id"], name: "index_posts_on_note_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
