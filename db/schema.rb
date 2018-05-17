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

ActiveRecord::Schema.define(version: 2018_05_17_221512) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.integer "group_type"
    t.integer "group_number"
    t.date "year_of_receipt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_type", "group_number", "year_of_receipt"], name: "index_groups_on_group_type_and_group_number_and_year_of_receipt", unique: true
  end

  create_table "groups_lessons", id: false, force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "lesson_id"
    t.index ["group_id"], name: "index_groups_lessons_on_group_id"
    t.index ["lesson_id"], name: "index_groups_lessons_on_lesson_id"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "user_id"
    t.string "lesson_name"
    t.string "lesson_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "question_selects", force: :cascade do |t|
    t.bigint "question_id"
    t.string "select_text"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_selects_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "variant_id"
    t.text "question_text"
    t.string "question_type"
    t.integer "question_point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_questions_on_variant_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "role_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "lesson_id"
    t.string "test_name"
    t.boolean "is_active"
    t.string "type_of_variant"
    t.integer "variants_count"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_tests_on_lesson_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "test_id"
    t.string "variant_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_variants_on_test_id"
  end

end
