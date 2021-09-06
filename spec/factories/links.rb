# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'url name' }
    url { 'https://www.google.com/' }
  end

  trait :linkable do
    association :linkable, factory: :answer
  end

  trait :valid_gist do
    url { 'https://gist.github.com/popeskul/234ed2442767c1b6df545a3433006cc1' }
  end

  trait :invalid_gist do
    url { 'https://gist.github.com/popeskul/' }
  end
end
