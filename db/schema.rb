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

ActiveRecord::Schema[7.1].define(version: 2024_05_22_134500) do
  create_table "lessons", force: :cascade do |t|
    t.string "chapter"
    t.string "title"
    t.string "description"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_lessons_on_question_id"
  end

  create_table "progres", force: :cascade do |t|
    t.string "progressLessons"
    t.string "progressQuestion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question", force: :cascade do |t|
    t.string "number"
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "names"
    t.string "username"
    t.string "email"
    t.string "password"
    t.integer "progres_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "questions_answered", default: 0
    t.integer "questions_correct", default: 0
    t.integer "questions_incorrect", default: 0
    t.index ["progres_id"], name: "index_users_on_progres_id"
  end

  add_foreign_key "lessons", "questions"
  add_foreign_key "questions", "lessons"
  add_foreign_key "users", "progres", column: "progres_id"
end
