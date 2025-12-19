# frozen_string_literal: true

module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      def initialize(content:, label: "Question.php")
        @content = content
        @label = label
      end
    end
  end
end
