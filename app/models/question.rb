# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :category
  has_many :question_choices, dependent: :destroy
  has_many :exam_questions
  accepts_nested_attributes_for :question_choices, allow_destroy: true, reject_if: :all_blank

  DEFAULT_CHOICES_COUNT = 4

  def update_or_version!(params)
    assign_attributes(params)
    return false unless valid?

    transaction do
      if in_use?
        Question::Versioner.new(self, params).create!
      else
        save!
        self
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def build_default_choices
    return if question_choices.present?
    DEFAULT_CHOICES_COUNT.times { question_choices.build }
  end

  def correct_choice_ids
    question_choices.where(correct: true).pluck(:id).sort
  end

  def answer_correct?(input_choice_ids)
    user_ids = Array(input_choice_ids).map(&:to_i).sort

    user_ids == correct_choice_ids
  end

  private
    def in_use?
      exam_questions.exists?
    end
end
