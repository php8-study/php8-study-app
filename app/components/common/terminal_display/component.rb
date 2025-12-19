# frozen_string_literal: true

module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      def initialize(body:, label: "Question.php")
        @content = body
        @label = label
      end
    end
  end
end
