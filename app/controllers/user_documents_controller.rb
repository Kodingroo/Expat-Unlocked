class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]
  # before_action :authenticate_user!

  def index; end

  def create
    @user_document = UserDocument.new(user_document_params)

    authorize @user_document

    VisionApi.detect_user_image(@user_document.photo)

    if @user_document.save
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

  def user_document_params
    params.require(:user_documents).permit(:title, :photo, :doc_type, :due_date, :remaining_balance, :current_due_amount, :reminder_date)
  end
end
