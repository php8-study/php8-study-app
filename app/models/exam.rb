# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :user

  has_many :exam_questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :exam_answers, through: :exam_questions

  def attach_questions!(question_ids)
    exam_questions_data = question_ids.each_with_index.map do |q_id, index|
      {
        exam_id: id,
        question_id: q_id,
        position: index + 1,
        created_at: Time.current,
        updated_at: Time.current
      }
    end
    ExamQuestion.insert_all(exam_questions_data)
  end

  def completed?
    completed_at.present?
  end

  def finish!
    update!(completed_at: Time.current) unless completed_at.present?
  end

  def score
    questions_with_answers = exam_questions.includes(
      :exam_answers,
      exam_answers: :question_choice
    ).all
    questions_with_answers.count(&:correct?)
  end
end
