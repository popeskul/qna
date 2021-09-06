# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyString' }
    association :author, factory: :user

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

    trait :with_files do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end
  end
end
