# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :category
  validates :content, presence: true
  has_many :question_choices, dependent: :destroy
  has_many :exam_questions, dependent: :restrict_with_error
  accepts_nested_attributes_for :question_choices, allow_destroy: true, reject_if: :all_blank

  DEFAULT_CHOICES_COUNT = 4

  scope :active, -> { where(deleted_at: nil) }

  def safe_update(params)
    assign_attributes(params)
    return false unless valid?

    if in_use?
      Question::Versioner.new(self, params).create_version!
    else
      save! && self
    end
  end

  def safe_destroy!
    return update!(deleted_at: Time.current) if in_use?
    destroy!
  end

  def build_default_choices
    return if question_choices.present?
    DEFAULT_CHOICES_COUNT.times { question_choices.build }
  end

  def correct_choice_ids
    question_choices.filter_map { |choice| choice.id if choice.correct? }.sort
  end

  def answer_correct?(input_choice_ids)
    user_ids = Array(input_choice_ids).map(&:to_i).sort

    user_ids == correct_choice_ids
  end

  def content_html
    MarkdownContent.new(self.content).to_html
  end

  def explanation_html
    MarkdownContent.new(self.explanation).to_html
  end

  private
    def in_use?
      exam_questions.exists?
    end
end
