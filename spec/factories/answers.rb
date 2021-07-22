FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.unique.sentence }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
