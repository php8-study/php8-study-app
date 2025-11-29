# frozen_string_literal: true

class ExamAnswer < ApplicationRecord
  belongs_to :exam_question, inverse_of: :exam_answers
  belongs_to :question_choice
end
