# frozen_string_literal: true

module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      INLINE_CODE_STYLE = "font-mono text-sm text-red-400 bg-slate-800 rounded px-1.5 py-0.5"

      def initialize(body:, label: "Question.php")
        @body = body
        @label = label
      end

      private
        def formatted_body
          MarkdownRenderer.render(
          @body,
          inline_code_style: INLINE_CODE_STYLE
        )
        end
    end
  end
end
