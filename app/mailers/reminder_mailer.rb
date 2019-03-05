class ReminderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reminder.subject
  #

  def reminder(user)
    @user = user  # Instance variable => available in view
    @reminder = "Hi, this is a reminder"

    Email.create!(name: user.first_name)
    mail to: "kodingroo@gmail.com", subject: "Reminder mail"
  end

end
