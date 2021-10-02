class NotificationMailer < ApplicationMailer
  def notification(user, answer)
    @user     = user
    @answer   = answer
    @question = answer.question

    mail to: @user.email, subject: t('notification_mailer.notification.subject')
  end
end
