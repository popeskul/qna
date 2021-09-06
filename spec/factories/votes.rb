# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    votable { |obj| obj.association(:question) }
    value { 1 }
  end

  factory :question_vote, class: Vote do
    association :user, factory: :user
    votable { |obj| obj.association(:question) }
    value { 1 }
  end

  factory :answer_vote, class: Vote do
    association :user, factory: :user
    votable { |obj| obj.association(:answer) }
    value { 1 }
  end
end
