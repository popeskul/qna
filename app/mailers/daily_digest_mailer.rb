# frozen_string_literal: true

# DailyDigestMailer
class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.where(updated_at: 24.hours.ago..Time.now)

    mail to: @user.email, subject: 'Daily Digest'
  end
end
