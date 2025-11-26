# frozen_string_literal: true

class CreateQuestionChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :question_choices do |t|
      t.string :content
      t.boolean :correct
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
