# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, presence: true
  validates :chapter_number, presence: true, numericality: { only_integer: true }
  validates :weight, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
end
