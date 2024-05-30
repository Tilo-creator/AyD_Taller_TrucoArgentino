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

ActiveRecord::Schema[7.1].define(version: 2024_05_16_185809) do
  create_table "lessons", force: :cascade do |t|
    t.string "chapter"
    t.string "title"
    t.string "description"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_lessons_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "description", null: false
    t.string "options", null: false
    t.string "correct_answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "names"
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "lessons", "questions"
end
