# frozen_string_literal: true

module Exams
  module QuestionList
    class Component < ViewComponent::Base
      def initialize(questions:, animation: false)
        @questions = questions
        @animation = animation
      end

      private
        def animation_class
          @animation ? "opacity-0" : ""
        end
    end
  end
end
