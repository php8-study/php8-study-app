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

ActiveRecord::Schema[8.0].define(version: 2025_12_07_153707) do
  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "chapter_number", null: false
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exam_answers", force: :cascade do |t|
    t.integer "exam_question_id", null: false
    t.integer "question_choice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_question_id", "question_choice_id"], name: "index_exam_answers_on_exam_question_id_and_question_choice_id", unique: true
    t.index ["exam_question_id"], name: "index_exam_answers_on_exam_question_id"
    t.index ["question_choice_id"], name: "index_exam_answers_on_question_choice_id"
  end

  create_table "exam_questions", force: :cascade do |t|
    t.integer "exam_id", null: false
    t.integer "question_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id", "position"], name: "index_exam_questions_on_exam_id_and_position", unique: true
    t.index ["exam_id", "question_id"], name: "index_exam_questions_on_exam_id_and_question_id", unique: true
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exams", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_exams_on_user_id"
  end

  create_table "question_choices", force: :cascade do |t|
    t.string "content"
    t.boolean "correct"
    t.integer "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_choices_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.text "explanation"
    t.integer "official_page"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_questions_on_category_id"
    t.index ["deleted_at"], name: "index_questions_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "github_id", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
  end

  add_foreign_key "exam_answers", "exam_questions", on_delete: :cascade
  add_foreign_key "exam_answers", "question_choices"
  add_foreign_key "exam_questions", "exams"
  add_foreign_key "exam_questions", "questions"
  add_foreign_key "exams", "users"
  add_foreign_key "question_choices", "questions"
  add_foreign_key "questions", "categories"
end
