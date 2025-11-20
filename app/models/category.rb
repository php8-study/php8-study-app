# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true
  validates :chapter_number, presence: true, numericality: { only_integer: true }
  validates :weight, numericality: true, allow_nil: true
end

