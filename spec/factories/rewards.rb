# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { 'reward' }
    association :question, factory: :question
  end
end
