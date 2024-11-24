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

ActiveRecord::Schema[7.1].define(version: 2024_10_08_145513) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lessons", force: :cascade do |t|
    t.string "chapter"
    t.string "title"
    t.string "description"
    t.bigint "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_lessons_on_question_id"
  end

  create_table "levels", force: :cascade do |t|
    t.integer "level_number", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_levels_on_user_id"
  end

  create_table "lives", force: :cascade do |t|
    t.integer "cantidadDeVidas", default: 3
    t.bigint "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_lives_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "description", null: false
    t.string "options", null: false
    t.string "correct_answer", null: false
    t.integer "vecesRespondidasBien", default: 0
    t.integer "vecesRespondidasMal", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "cantidadDePreguntaRespondidas", default: 0
    t.integer "cantPregRespondidasBien", default: 0
    t.integer "cantPregRespondidasMal", default: 0
    t.integer "total_points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_statistics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "names"
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "isAdmin", default: false
  end

  add_foreign_key "lessons", "questions"
  add_foreign_key "levels", "users"
  add_foreign_key "lives", "users"
  add_foreign_key "statistics", "users"
end
