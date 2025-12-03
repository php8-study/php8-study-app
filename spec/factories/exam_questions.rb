FactoryBot.define do
  factory :exam_question do
    association :exam
    association :question

    sequence(:position) { |n| n }
  end
end
