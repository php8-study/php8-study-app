# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :user
  # ※ 紐付くExamAnswerは、DB側の外部キー制約(on_delete: :cascade)により連鎖削除されるため安全
  has_many :exam_questions, -> { order(position: :asc) }, dependent: :delete_all
  has_many :exam_answers, through: :exam_questions
  has_many :questions, through: :exam_questions

  PASSING_SCORE_PERCENTAGE = 70.0

  def attach_questions!(question_ids)
    now = Time.current

    exam_questions_data = question_ids.each_with_index.map do |question_id, index|
      {
        exam_id: id,
        question_id:,
        position: index + 1,
        created_at: now,
        updated_at: now
      }
    end

    ExamQuestion.insert_all(exam_questions_data)
  end

  def completed?
    completed_at.present?
  end

  def finish!
    update!(completed_at: Time.current) if completed_at.blank?
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
