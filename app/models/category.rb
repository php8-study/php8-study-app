# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :questions
  before_destroy :ensure_no_questions

  validates :name, presence: true
  validates :chapter_number, presence: true, numericality: { only_integer: true }
  validates :weight, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  private

  def ensure_no_questions
    if questions.exists?
      errors.add(:base, "このカテゴリーには問題が紐付いているため削除できません。先に問題を移動または削除してください。")
      throw :abort
    end
  end
end



