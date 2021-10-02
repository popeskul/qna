# frozen_string_literal: true

# Reputation service
module Services
  # implement Reputation
  class Notification
    def send_notification(answer)
      subscriptions = answer.question.subscriptions
      subscriptions.find_each do |subscription|
        NotificationMailer.notification(subscription.user, answer).deliver_later
      end
    end
  end
end
