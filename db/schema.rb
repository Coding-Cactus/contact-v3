# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_19_090842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ticket_id", null: false
    t.text "content"
    t.boolean "moderator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_contact_comments_on_ticket_id"
    t.index ["user_id"], name: "index_contact_comments_on_user_id"
  end

  create_table "contact_infractions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action"
    t.string "reason"
    t.string "moderator"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ticket_id", null: false
    t.index ["ticket_id"], name: "index_contact_infractions_on_ticket_id"
    t.index ["user_id"], name: "index_contact_infractions_on_user_id"
  end

  create_table "contact_tickets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count"
    t.integer "status", default: 0
    t.integer "appeal_type", default: 0
    t.index ["user_id"], name: "index_contact_tickets_on_user_id"
  end

  create_table "contact_users", force: :cascade do |t|
    t.string "username"
    t.string "pfp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contact_comments", "contact_tickets", column: "ticket_id"
  add_foreign_key "contact_comments", "contact_users", column: "user_id"
  add_foreign_key "contact_infractions", "contact_tickets", column: "ticket_id"
  add_foreign_key "contact_infractions", "contact_users", column: "user_id"
  add_foreign_key "contact_tickets", "contact_users", column: "user_id"
end
