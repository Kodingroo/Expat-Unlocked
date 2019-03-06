class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index, :show]
  before_action :set_user_document, only: [:show, :update]
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
      api_data = VisionApi.detect_user_image(@user_document.photo.metadata["secure_url"])
      @document = find_document(api_data[:words])
      assign_data(@user_document, api_data)
      @user_document.save!

      redirect_to user_document_path(@user_document), notice: 'Document was successfully created.'
    else
      render "pages/home"
    end
  end

  def show
    authorize @user_document
  end

  def update
    @user_document.update(user_document_params)
    authorize @user_document
    if @user_document.save
      redirect_to user_document_path(@user_document)
    else
      render :show
    end
  end

  private

  def assign_data(user_document, api_data)
    p api_data[:due_amount]
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
    p doc_to_add
    Document.find_by(jp_name: doc_to_add)
  end

  def set_user_document
    @user_document = UserDocument.find(params[:id])
  end

  def user_document_params
    params.require(:user_document).permit(:title, :photo, :doc_type, :due_date, :remaining_balance, :current_due_amount, :reminder_date)
  end
end
