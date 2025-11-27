# frozen_string_literal: true

class ExamAnswer < ApplicationRecord
  belongs_to :exam_question
  belongs_to :question_choice
end
