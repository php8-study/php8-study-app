# frozen_string_literal: true

module ExamQuestions
  module Header
    class Component < ViewComponent::Base
      def initialize(exam:, exam_question:)
        @exam = exam
        @exam_question = exam_question
      end

      private
        def position
          @exam_question.position
        end

        def total
          @exam.exam_questions.size
        end
    end
  end
end
