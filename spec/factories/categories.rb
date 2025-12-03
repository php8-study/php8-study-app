FactoryBot.define do
  factory :category do
    sequence(:name) { Faker::Book.unique.genre }
    sequence(:chapter_number) { |n| n }
    weight { 10.0 }
  end
end
