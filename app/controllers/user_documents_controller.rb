class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]
  # before_action :authenticate_user!

  def index; end

  def create
    @user_document = UserDocument.new(user_document_params)

    authorize @user_document

    @user_document.user = current_user
    @user_document.document = Document.first
 
    if @user_document.save
      @user_document.document = find_document(@user_document)
      redirect_to @user_document, notice: 'Document was successfully created.'
    else
      render :root
    end
  end

  def show
  end

  def update
  end

  private

  def find_document(user_document)
    words = VisionApi.detect_user_image(user_document.photo)

    document = Document.all.select do |doc|
      words.include?(doc.title)
    end
    
    document
  end

  def user_document_params
    params.require(:user_document).permit(:title, :photo, :doc_type, :due_date, :remaining_balance, :current_due_amount, :reminder_date)
  end
end
