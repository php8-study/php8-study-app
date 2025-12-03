# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    github_id { Faker::Number.unique.number(digits: 8).to_s }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
