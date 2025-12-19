# frozen_string_literal: true

module Exams
  module ResultReveal
    class Component < ViewComponent::Base
      def initialize(exam:, animation: false)
        @exam = exam
        @animation = animation
      end

      def call
        tag.div(
          data: {
            controller: stimulus_controller,
            result_reveal_score_value: @exam.score_percentage,
            result_reveal_passed_value: @exam.passed?
          },
          class: "relative pb-24"
        ) do
          content
        end
      end

      private
        def stimulus_controller
          "result-reveal" if @animation
        end
    end
  end
end
