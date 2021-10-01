# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def notification
    NotificationMailer.notification(User.first, Answer.first)
  end
end
