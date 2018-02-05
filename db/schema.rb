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

ActiveRecord::Schema.define(version: 20180121142431) do

  create_table "notes", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "type"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitter_id"
    t.string "media_urls"
  end

  create_table "users", force: :cascade do |t|
    t.string "twitter_id"
    t.string "name"
    t.string "screen_name"
    t.string "url"
    t.string "thumb_url"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_group_info"
    t.string "permission", default: ""
  end

end
