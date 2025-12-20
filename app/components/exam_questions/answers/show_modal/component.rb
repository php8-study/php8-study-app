# frozen_string_literal: true

module ExamQuestions
  module Answers
    module ShowModal
      class Component < ViewComponent::Base
        def initialize(exam_question:)
          @exam_question = exam_question
          @question = exam_question.question
        end

        private
          def header_data
            if @exam_question.correct?
              {
                title: "正解の解説",
                icon: "icons/check.svg",
                icon_wrapper_class: "bg-emerald-100 text-emerald-600"
              }
            else
              {
                title: "不正解の解説",
                icon: "icons/x.svg",
                icon_wrapper_class: "bg-red-100 text-red-600"
              }
            end
          end
      end
    end
  end
end
