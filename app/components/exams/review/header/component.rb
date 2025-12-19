# frozen_string_literal: true

module Exams
  module Review
    module Header
      class Component < ViewComponent::Base
        def initialize(exam:)
          @exam = exam
        end

        def progress_percentage
          return 0 if @exam.total_questions.zero?
          (@exam.answered_count.to_f / @exam.total_questions * 100).round
        end

        def answered_count
          @exam.answered_count
        end

        def total_questions
          @exam.total_questions
        end
      end
    end
  end
end
