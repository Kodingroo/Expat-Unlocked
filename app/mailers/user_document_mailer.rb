class UserDocumentMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_document_mailer.creation_confirmation.subject
  def creation_confirmation(user_document)
    @user_document = user_document

    mail(
      to: @user_document.user.email,
      subject: "#{@user_document.title} bill created!"
    )
  end
end
