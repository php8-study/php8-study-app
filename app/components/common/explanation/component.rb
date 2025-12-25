# frozen_string_literal: true

module Common
  module Explanation
    class Component < ViewComponent::Base
      def initialize(question:)
        @question = question
      end

      def render?
        @question.explanation.present?
      end
    end
  end
end
