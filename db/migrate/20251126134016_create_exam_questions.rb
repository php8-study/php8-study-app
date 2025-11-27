# frozen_string_literal: true

class CreateExamQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps

      t.index [:exam_id, :question_id], unique: true
      t.index [:exam_id, :position], unique: true
    end
  end
end
