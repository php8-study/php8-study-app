# frozen_string_literal: true

module Common
  module TerminalDisplay
    class Component < ViewComponent::Base
      WRAPPER_STYLE = %w(
        markdown-body
        font-mono
        text-base md:text-lg
        leading-relaxed
        text-slate-300
        break-words
        [&_:not(pre)>code]:font-mono
        [&_:not(pre)>code]:text-sm
        [&_:not(pre)>code]:text-slate-200
        [&_:not(pre)>code]:bg-slate-800
        [&_:not(pre)>code]:rounded
        [&_:not(pre)>code]:px-1.5
        [&_:not(pre)>code]:py-0.5
      ).join(" ").freeze

      def initialize(body:, label: "Question.php")
        @body = body
        @label = label
      end

      def formatted_body
        MarkdownContent.new(@body).to_html
      end
    end
  end
end
