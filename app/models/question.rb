# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :category
  has_many :question_choices, dependent: :destroy
  accepts_nested_attributes_for :question_choices, allow_destroy: true, reject_if: :all_blank
end
