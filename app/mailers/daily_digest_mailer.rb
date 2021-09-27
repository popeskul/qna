# frozen_string_literal: true

# DailyDigestMailer
class DailyDigestMailer < ApplicationMailer
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = 'Hi'

    mail to: user.email
  end
end
