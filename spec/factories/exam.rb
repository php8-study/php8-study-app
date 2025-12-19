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

    trait :with_questions do
      transient do
        questions { [] }
        question_count { 3 }
        answered_count { 0 }
      end

      after(:create) do |exam, evaluator|
        target_questions = if evaluator.questions.present?
          evaluator.questions
        else
          create_list(:question, evaluator.question_count, :with_choices)
        end

        target_questions.each_with_index do |question, index|
          eq = create(:exam_question, exam: exam, question: question, position: index + 1)

          if index < evaluator.answered_count
            choice = question.question_choices.first
            create(:exam_answer, exam_question: eq, question_choice: choice)
          end
        end
      end
    end

    # 使用例: create(:exam, :with_score, correct_count: 8, question_count: 10) -> 80点
    trait :with_score do
      completed

      transient do
        correct_count { 8 }
        question_count { 10 }
      end

      after(:create) do |exam, evaluator|
        questions = create_list(:question, evaluator.question_count, :with_choices)

        questions.each_with_index do |question, index|
          eq = create(:exam_question, exam: exam, question: question, position: index + 1)

          target_choice = if index < evaluator.correct_count
            question.question_choices.find_by(correct: true)
          else
            question.question_choices.where(correct: false).first
          end

          create(:exam_answer, exam_question: eq, question_choice: target_choice)
        end
      end
    end
  end
end
