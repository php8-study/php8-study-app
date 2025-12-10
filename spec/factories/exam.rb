# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    association :user
    completed_at { nil }

    trait :completed do
      completed_at { Time.current }
    end

    trait :passed do
      completed
      after(:create) do |exam|
        question = create(:question, :with_choices)
        eq = create(:exam_question, exam: exam, question: question)
        correct_choice = question.question_choices.find_by(correct: true)
        create(:exam_answer, exam_question: eq, question_choice: correct_choice)
      end
    end

    trait :failed do
      completed
      after(:create) do |exam|
        question = create(:question, :with_choices)
        eq = create(:exam_question, exam: exam, question: question)
        wrong_choice = question.question_choices.where(correct: false).first
        create(:exam_answer, exam_question: eq, question_choice: wrong_choice)
      end
    end
  end
end
