# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail.com"
  end

  factory :user do
    email
    password { 'MyString' }
    password_confirmation { 'MyString' }
  end
end
