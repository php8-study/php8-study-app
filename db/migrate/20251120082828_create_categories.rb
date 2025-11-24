# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :chapter_number, null: false
      t.float :weight

      t.timestamps
    end
    add_index :categories, :chapter_number, unique: true
    add_check_constraint :categories, "weight >= 0.0 AND weight <= 100.0", name: "weight_check"
  end
end
