# frozen_string_literal: true

FactoryBot.define do
  factory :exam_answer do
    association :exam_question
    question_choice do
      association :question_choice, question: exam_question.question
    end
  end
end
