# frozen_string_literal: true

# DailyDigestJob
class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::DailyDigestMailer.new.send_digest
  end
end
