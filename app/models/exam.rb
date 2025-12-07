# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :user

  has_many :exam_questions, -> { order(position: :asc) }, dependent: :delete_all
  has_many :exam_answers, through: :exam_questions

  PASSING_SCORE_PERCENTAGE = 70.0

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

  def total_questions
    exam_questions.size
  end

  def answered_count
    exam_questions.count(&:answered?)
  end

  def correct_count
    exam_questions.count(&:correct?)
  end

  def score_percentage
    total = exam_questions.size
    return 0.0 if total.zero?

    (correct_count.to_f / total * 100).round(1)
  end

  def passed?
    score_percentage >= PASSING_SCORE_PERCENTAGE
  end
end
