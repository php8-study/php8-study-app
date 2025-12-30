# frozen_string_literal: true

module Common
  module Choices
    class Component < ViewComponent::Base
      WRAPPER_STYLE = %w[
        [&_code]:font-mono
        [&_code]:text-sm
        [&_code]:text-slate-700
        [&_code]:bg-slate-100
        [&_code]:rounded
        [&_code]:leading-relaxed
        [&_code]:px-1.5
        [&_code]:py-0.5
      ].join(" ").freeze

      def initialize(question:, input_name: nil, selected_choice_ids: [], disabled: false)
        @question = question
        @input_name = input_name
        @selected_choice_ids = Array(selected_choice_ids).map(&:to_i)
        @disabled = disabled
      end

      def formatted_content(content)
        MarkdownContent.new(content).to_html
      end

      private
        def checkbox_name(choice)
          @input_name.presence || "choice_#{choice.id}_disabled"
        end

        def checked?(choice)
          @selected_choice_ids.include?(choice.id)
        end

        def text_classes
          classes = %w[
            block text-base text-slate-700 group-hover:text-indigo-900 transition-colors
          ]

          classes << WRAPPER_STYLE

          classes << "peer-checked:font-bold" unless @disabled
          classes.join(" ")
        end
    end
  end
end
