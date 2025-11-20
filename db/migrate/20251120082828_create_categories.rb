class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :chapter_number, null: false
      t.float :weight

      t.timestamps
    end
  end
end
