# frozen_string_literal: true

module Exams
  module Review
    module QuestionItem
      class Component < ViewComponent::Base
        def initialize(exam:, question:)
          @exam = exam
          @question = question
        end

        def call
          link_to exam_exam_question_path(@exam, @question), class: classes do
            content
          end
        end

        private
          def classes
            base_classes = "flex flex-col items-center justify-center h-20 rounded-2xl transition-all duration-200 relative group"

            status_classes = if @question.answered?
              "bg-indigo-50 border border-indigo-100 text-indigo-700 hover:bg-indigo-100 hover:border-indigo-200 hover:-translate-y-1 shadow-sm"
            else
              "bg-white border-2 border-slate-300 border-dashed text-slate-400 hover:border-slate-400 hover:text-slate-600 hover:bg-slate-50"
            end

            "#{base_classes} #{status_classes}"
          end
      end
    end
  end
end
