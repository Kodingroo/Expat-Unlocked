class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  # en.user_mailer.reminder.subject
  def welcome(user)
    # @user = user # Instance variable => available in view
    # @greeting = "Hi, hows it going mate?"

    # Email.create!(name: user.first_name)
    # mail to: "sherly@hartono.info", subject: "Test mail"
    # This will render a view in `app/views/user_mailer`!
  end
end
