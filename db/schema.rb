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

ActiveRecord::Schema.define(version: 20180227013028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "box_tokens", force: :cascade do |t|
    t.string "token"
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "code"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbrev"
    t.string "folder_id"
  end

  create_table "lectures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "folder_id"
    t.date "date"
    t.integer "number"
  end

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "semesters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "folder_id"
    t.string "year"
    t.bigint "course_id"
    t.bigint "videos_id"
    t.index ["course_id"], name: "index_semesters_on_course_id"
    t.index ["videos_id"], name: "index_semesters_on_videos_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.decimal "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "tags", default: [], array: true
    t.integer "category_id"
    t.string "privacyStatus"
    t.integer "course_id"
    t.string "path"
    t.bigint "semester_id"
    t.integer "number"
    t.string "folder_id"
    t.index ["semester_id"], name: "index_videos_on_semester_id"
  end

end
