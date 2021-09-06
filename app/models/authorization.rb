# frozen_string_literal: true

# model Authorization
class Authorization < ApplicationRecord
  belongs_to :user

  validates :user, :provider, :uid, presence: true
end
