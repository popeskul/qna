# frozen_string_literal: true

# ReputationJob
class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::Reputation.calculate(object)
  end
end
