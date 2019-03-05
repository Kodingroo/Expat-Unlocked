class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @greeting = "Hi"
    @user = user  # Instance variable => available in view

    # Email.create! (name: ~)
    mail(to: "kodingroo@gmail.com", subject: "Testing it all out")
  end
end
