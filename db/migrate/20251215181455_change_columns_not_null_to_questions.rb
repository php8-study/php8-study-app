# frozen_string_literal: true

class ChangeColumnsNotNullToQuestions < ActiveRecord::Migration[8.1]
  def change
    change_column_null :questions, :content, false
    change_column_null :questions, :category_id, false
  end
end
