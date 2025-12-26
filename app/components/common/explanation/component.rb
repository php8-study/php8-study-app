# frozen_string_literal: true

module Common
  module Explanation
    class Component < ViewComponent::Base
      WRAPPER_STYLE = %w(
        [&_code]:font-mono
        [&_code]:text-sm
        [&_code]:text-slate-700
        [&_code]:bg-slate-100
        [&_code]:rounded
        [&_code]:leading-relaxed
        [&_code]:px-1.5
        [&_code]:py-0.5
      ).join(" ").freeze

      def initialize(question:)
        @question = question
      end

      def render?
        @question.explanation.present?
      end

      private

      def explanation_html
        MarkdownContent.new(@question.explanation).to_html
      end
    end
  end
end
