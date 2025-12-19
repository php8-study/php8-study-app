# frozen_string_literal: true

module Questions
  module ChoicesFeedback
    class Component < ViewComponent::Base
      def initialize(question:, user_choice_ids: [])
        @question = question
        @user_choice_ids = user_choice_ids
      end

      private
        def choices
          @question.question_choices
        end

        def selected?(choice)
          @user_choice_ids.include?(choice.id)
        end

        def correct?(choice)
          choice.correct
        end

        def container_classes(choice)
          base = "relative flex items-start p-4 rounded-xl border-2 transition-all"
          style = if correct?(choice)
            "bg-emerald-50 border-emerald-500 ring-1 ring-emerald-500"
          elsif selected?(choice)
            "bg-red-50 border-red-400 border-dashed"
          else
            "bg-white border-slate-200 opacity-70"
          end
          "#{base} #{style}"
        end

        def text_classes(choice)
          base = "text-slate-700 font-medium leading-relaxed"
          base += " text-emerald-900 font-bold" if correct?(choice)
          base
        end
    end
  end
end
