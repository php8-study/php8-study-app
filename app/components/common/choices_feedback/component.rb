# frozen_string_literal: true

module Common
  module ChoicesFeedback
    class Component < ViewComponent::Base
      WRAPPER_STYLE = %w[
        [&_code]:font-mono
        [&_code]:text-sm
        [&_code]:bg-slate-100
        [&_code]:rounded
        [&_code]:leading-relaxed
        [&_code]:px-1.5
        [&_code]:py-0.5
      ].join(" ").freeze

      def initialize(question:, user_choice_ids: [])
        @question = question
        @user_choice_ids = user_choice_ids
      end

      private
        def choices
          @question.question_choices
        end

        def container_classes(choice)
          [
            %w[relative flex items-start p-4 rounded-xl border-2 transition-all],
            container_status_styles(choice)
          ].flatten.join(" ")
        end

        def text_classes(choice)
          classes = %w[text-slate-700 font-medium leading-relaxed]

          classes << WRAPPER_STYLE

          classes.concat %w[text-emerald-900 font-bold] if correct?(choice)

          classes.join(" ")
        end

        def container_status_styles(choice)
          if correct?(choice)
            %w[bg-emerald-50 border-emerald-500 ring-1 ring-emerald-500]
          elsif selected?(choice)
            %w[bg-red-50 border-red-400 border-dashed]
          else
            %w[bg-white border-slate-200 opacity-70]
          end
        end

        def selected?(choice)
          @user_choice_ids.include?(choice.id)
        end

        def correct?(choice)
          choice.correct
        end

        def formatted_content(content)
          MarkdownContent.new(content).to_html
        end
    end
  end
end
