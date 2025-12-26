# frozen_string_literal: true

module Common
  module Explanation
    class Component < ViewComponent::Base
      INLINE_CODE_STYLE = "font-mono text-sm text-red-400 bg-slate-100 rounded px-1.5 py-0.5"

      def initialize(question:)
        @question = question
      end

      def render?
        @question.explanation.present?
      end

      private
        def formatted_explanation
          MarkdownRenderer.render(@question.explanation, inline_code_style: INLINE_CODE_STYLE)
        end
    end
  end
end
