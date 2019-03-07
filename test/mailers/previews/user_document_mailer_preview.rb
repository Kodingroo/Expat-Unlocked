# Preview all emails at http://localhost:3000/rails/mailers/user_document_mailer
class UserDocumentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_document_mailer/creation_confirmation
  def creation_confirmation
    UserDocumentMailer.creation_confirmation
  end

end
