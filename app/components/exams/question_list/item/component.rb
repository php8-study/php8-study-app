# frozen_string_literal: true

module Exams
  module QuestionList
    module Item
      class Component < ViewComponent::Base
        def initialize(exam_question:)
          @exam_question = exam_question
          @question = exam_question.question
        end

        private
          def render?
            @exam_question.present?
          end

          def status_color_class
            @exam_question.correct? ? "bg-emerald-100 text-emerald-600" : "bg-red-100 text-red-600"
          end

          def status_icon
            @exam_question.correct? ? "icons/check.svg" : "icons/x.svg"
          end

          def category_name
            @question.category&.name
          end

          def has_category?
            @question.category.present?
          end

          def question_summary
            @question.content.truncate(100)
          end
      end
    end
  end
end
