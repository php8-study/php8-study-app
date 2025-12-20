# frozen_string_literal: true

module ExamQuestions
  module Navigation
    class Component < ViewComponent::Base
      def initialize(exam:, exam_question:)
        @exam = exam
        @exam_question = exam_question
      end

      private
        def prev_question
          @prev_question ||= @exam_question.previous_question
        end

        def next_question
          @next_question ||= @exam_question.next_question
        end
    end
  end
end
