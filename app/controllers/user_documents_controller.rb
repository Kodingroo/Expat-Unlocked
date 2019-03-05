class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index, :show]
  before_action :set_user_document, only: :show
  # before_action :authenticate_user!

  def index
    @user_document = policy_scope(UserDocument)
  end

  def create
<<<<<<< HEAD
    @user_document = UserDocument.new(user_document_params)

    authorize @user_document

    @user_document.user = current_user

    if @user_document.save
      @document = find_document(@user_document.photo.metadata["secure_url"])
      @user_document.document = @document
      @user_document.save
      
      redirect_to user_document_path(@user_document), notice: 'Document was successfully created.'
    else
      render "pages/home"
    end
=======
    # The user image will be passed through this method
    # The method will hit the api and get the required data
    # TODO: Get all japanese text. Translate text.
    # VisionApi.detect_user_image(image)


    # FOR REMINDER EMAILS
    # @user = current_user.build(user_params)
    # UserDocumentMailer.reminder(@user).deliver_now
>>>>>>> master
  end

  def show
    authorize @user_document
  end

  def update
  end

<<<<<<< HEAD
  private

  def find_document(image)
    words = VisionApi.detect_user_image(image)

    names = Document.all.map { |doc| doc.doc_name }
    doc_to_add = ""

    words.each do |word|
      names.any? do |name| 
        unless word.nil?
          doc_to_add = name if word.include?(name)
        end
      end
    end

    Document.find_by(doc_name: doc_to_add)
  end

  def set_user_document
    @user_document = UserDocument.find(params[:id])
  end
  
  def user_document_params
    params.require(:user_document).permit(:title, :photo, :doc_type, :due_date, :remaining_balance, :current_due_amount, :reminder_date)
  end
end
=======
end
>>>>>>> master
