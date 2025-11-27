# frozen_string_literal: true

class ExamQuestion < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  has_many :exam_answers, dependent: :destroy

  def answered?
    exam_answers.exists?
  end

  def correct?
    correct_choices = question.question_choices.where(correct: true).pluck(:id).to_set
    user_choices = exam_answers.map(&:question_choice_id).to_set
    correct_choices == user_choices
  end

  def next_question
    exam.exam_questions.order(:position).find_by(position: position + 1)
  end
end
