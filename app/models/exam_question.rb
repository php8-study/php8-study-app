# frozen_string_literal: true

class ExamQuestion < ApplicationRecord
  belongs_to :exam, inverse_of: :exam_questions
  belongs_to :question, inverse_of: :exam_questions
  has_many :exam_answers, inverse_of: :exam_question, dependent: :destroy

  def save_answers!(choice_ids)
      input_ids = Array(choice_ids).map(&:to_i).uniq
      valid_choice_ids = question.question_choices.map(&:id)
      target_choice_ids = input_ids & valid_choice_ids
      current_time = Time.current

      transaction do
        exam_answers.delete_all
        return if target_choice_ids.empty?

        answers = target_choice_ids.map do |choice_id|
          {
            exam_question_id: id,
            question_choice_id: choice_id,
            created_at: current_time,
            updated_at: current_time
          }
        end
        ExamAnswer.insert_all!(answers)
      end
  end

  def next_question
    exam.exam_questions.order(:position).find_by("position > ?", position)
  end

  def previous_question
    exam.exam_questions.order(:position).find_by("position < ?", position)
  end

  def correct?
    correct_ids = question.question_choices.filter_map { |choice| choice.id if choice.correct? }.sort
    student_ids = exam_answers.map(&:question_choice_id).sort

    correct_ids == student_ids
  end
end
