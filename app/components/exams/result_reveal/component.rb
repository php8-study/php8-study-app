# frozen_string_literal: true

module Exams
  module ResultReveal
    class Component < ViewComponent::Base
      def initialize(exam:, animation: false)
        @exam = exam
        @animation = animation
      end

      def call
        data_attributes = {
          result_reveal_passed_value: @exam.passed?
        }

        if @animation
          data_attributes[:controller] = "result-reveal confetti"

          data_attributes[:result_reveal_confetti_outlet] = "#reveal-wrapper"
          data_attributes[:result_reveal_chart_animation_outlet] = "#result-chart-bar"
          data_attributes[:result_reveal_number_animation_outlet] = "#result-score-text"
        end

        tag.div(
          id: "reveal-wrapper",
          data: data_attributes,
          class: "relative"
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
