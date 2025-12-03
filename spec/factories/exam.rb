# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    association :user
    completed_at { nil }

    trait :completed do
      completed_at { Time.current }
    end
  end
end
