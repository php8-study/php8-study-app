# frozen_string_literal: true

FactoryBot.define do
  factory :question_choice do
    association :question
    content { Faker::Lorem.sentence(word_count: 3) }
    correct { false }
  end
end
