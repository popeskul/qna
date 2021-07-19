FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyString" }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers, class: Question do
      title { Faker::Lorem.unique.sentence }
      body { Faker::Lorem.unique.paragraph }

      after(:create) do |question_with_answers, _evaluator|
        create_list(:answer, 2, question: question_with_answers)
      end
    end
  end
end
