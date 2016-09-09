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

ActiveRecord::Schema.define(version: 20160712101549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.integer  "category_id"
    t.boolean  "is_enable",   default: false
    t.boolean  "is_draft",    default: false
    t.string   "ru_name"
    t.string   "com_name"
    t.string   "ru_content"
    t.string   "com_content"
    t.datetime "get_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string  "ru_name"
    t.string  "com_name"
    t.string  "ru_description"
    t.string  "com_description"
    t.integer "order_number"
    t.boolean "is_enable",       default: false
  end

  create_table "photo_tag_photos", id: false, force: :cascade do |t|
    t.integer "photo_id"
    t.integer "photo_tag_id"
  end

  create_table "photo_tags", force: :cascade do |t|
    t.string "name"
    t.string "locale"
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "album_id"
    t.string   "ru_name"
    t.string   "com_name"
    t.string   "ru_description"
    t.string   "com_description"
    t.datetime "get_at"
    t.string   "link"
    t.string   "file_name"
    t.boolean  "is_enable",         default: false
    t.boolean  "is_album_photo",    default: false
    t.boolean  "is_category_photo", default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.float    "bg_opacity",        default: 1.0
  end

  create_table "users", force: :cascade do |t|
    t.string   "ru_name"
    t.string   "com_name"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "email"
    t.string   "vk_url"
    t.string   "fb_url"
    t.integer  "user_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
