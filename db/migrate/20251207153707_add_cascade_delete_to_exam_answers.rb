# frozen_string_literal: true

class AddCascadeDeleteToExamAnswers < ActiveRecord::Migration[7.0] # バージョンは環境に合わせて
  def up
    remove_foreign_key :exam_answers, :exam_questions
    add_foreign_key :exam_answers, :exam_questions, on_delete: :cascade
  end

  def down
    remove_foreign_key :exam_answers, :exam_questions
    add_foreign_key :exam_answers, :exam_questions
  end
end
