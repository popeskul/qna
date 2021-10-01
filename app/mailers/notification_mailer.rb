class NotificationMailer < ApplicationMailer
  def notification(user, answer)
    @user     = user
    @answer   = answer
    @question = answer.question

    mail to: @user.email, subject: 'You have got a new answer to your question'
  end
end
