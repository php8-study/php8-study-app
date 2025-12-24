module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      def initialize(body:, label: "Question.php")
        @body = body
        @label = label
      end

      private
        def formatted_body
          MarkdownRenderer.render(@body)
        end
    end
  end
end
