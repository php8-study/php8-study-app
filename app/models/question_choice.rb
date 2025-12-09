# frozen_string_literal: true

class QuestionChoice < ApplicationRecord
  belongs_to :question
  has_many :exam_answers, dependent: :destroy
end
