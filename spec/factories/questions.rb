# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    association :category
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    explanation { Faker::Lorem.paragraph(sentence_count: 2) }
    official_page { Faker::Number.between(from: 1, to: 300) }

    trait :with_choices do
      after(:create) do |question|
        create(:question_choice, question: question, correct: true)
        create_list(:question_choice, 3, question: question)
      end
    end
  end
end
