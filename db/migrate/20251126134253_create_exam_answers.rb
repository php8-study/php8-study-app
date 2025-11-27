# frozen_string_literal: true

class CreateExamAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_answers do |t|
      t.references :exam_question, null: false, foreign_key: true
      t.references :question_choice, null: false, foreign_key: true

      t.timestamps

      t.index [:exam_question_id, :question_choice_id], unique: true
    end
  end
end
