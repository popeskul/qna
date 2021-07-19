FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.unique.sentence }

    trait :invalid do
      body { nil }
    end
  end
end
