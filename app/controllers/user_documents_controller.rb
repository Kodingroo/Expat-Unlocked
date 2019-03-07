class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index, :show]
  before_action :set_user_document, only: [:show, :update, :destroy]
  # before_action :authenticate_user!

  def index
    @user_documents = policy_scope(UserDocument).order(created_at: :desc)
    @user_document = UserDocument.new
  end

  def create
    @user_document = UserDocument.new(user_document_params)

    authorize @user_document

    @user_document.user = current_user

    if @user_document.save
      UserDocumentMailer.creation_confirmation(@user_document).deliver_now
      api_data = VisionApi.detect_user_image(@user_document.photo.metadata["secure_url"])
      @document = find_document(api_data[:words])
      assign_data(@user_document, api_data)
      @user_document.save

      redirect_to user_document_path(@user_document), notice: 'Document was successfully created.'
    else
      flash[:alert] = "You haz errors!"
      render :index
    end
  end

  def show
    authorize @user_document
  end

  def update
    @old_date = @user_document.reminder_date
    @user_document.update(user_document_params)
    authorize @user_document
    if @user_document.save && @old_date != @user_document.reminder_date
      UserDocumentMailer.creation_confirmation(@user_document).deliver_now
      redirect_back fallback_location: user_document_path(@user_document)
    else
      redirect_back fallback_location: user_document_path(@user_document)
    end
  end

  def destroy
    authorize @user_document
    @user_document.destroy
    redirect_to user_documents_path
  end

  private

  def assign_data(user_document, api_data)
    user_document.document = @document
    user_document.due_date = api_data[:due_date]
    user_document.reminder_date = (api_data[:due_date] - 10)
    user_document.current_due_amount = api_data[:due_amount]
    user_document.remaining_balance = api_data[:due_amount]
  end

  def find_document(words)
    names = Document.all.map(&:jp_name)
    doc_to_add = ""
   
    words.each do |word|
      names.any? do |name|
        unless word.nil?
          doc_to_add = name if word.include?(name)
        end
      end
    end

    doc_to_add
    Document.find_by(jp_name: doc_to_add)
  end

  def set_user_document
    @user_document = UserDocument.find(params[:id])
  end

  def user_document_params
    params.require(:user_document).permit(:title, :photo, :doc_type, :due_date, :remaining_balance, :current_due_amount, :reminder_date, :state)
  end
end

