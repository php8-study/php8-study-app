# frozen_string_literal: true

module Common
  module Choices
    class Component < ViewComponent::Base
      def initialize(question:, input_name: nil, selected_choice_ids: [], disabled: false)
        @question = question
        @input_name = input_name
        @selected_choice_ids = Array(selected_choice_ids).map(&:to_i)
        @disabled = disabled
      end

      private
        def checkbox_name(choice)
          @input_name.presence || "choice_#{choice.id}_disabled"
        end

        def checked?(choice)
          @selected_choice_ids.include?(choice.id)
        end

        def text_classes
          classes = "block text-base text-slate-700 group-hover:text-indigo-900 transition-colors"
          classes += " peer-checked:font-bold" unless @disabled
          classes
        end
    end
  end
end
