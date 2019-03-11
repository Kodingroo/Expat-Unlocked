class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index, :show]
  before_action :set_user_document, only: [:show, :update, :pay, :unpaid]
  # before_action :authenticate_user!

  def index
    @user_documents = policy_scope(UserDocument).order(created_at: :desc)
    @user_document = UserDocument.new

    @sort_by = ["due date", "most expensive", "least expensive"]
    @categories = ["all"]
    @collection_type = params[:sort_by]

    unless params[:category]
      params[:category] = "all"
    end

    if @user_documents.exists?
      @user_documents.each do |doc|
        @categories << doc.document.company_name
      end

      @categories.uniq!
      @collection_type = params[:sort_by]

      unless params[:category] == "all"
        @user_documents = @user_documents.reject { |doc| doc.document.company_name != params[:category] }
      end

      @user_documents = if params[:category] == "all"
        if params[:sort_by] == "due date"
          @user_documents.sort_by { |doc| doc.due_date }
        elsif params[:sort_by] == "most expensive"
          @user_documents.sort_by { |doc| -doc.current_due_amount }
        elsif params[:sort_by] == "least expensive"
          @user_documents.sort_by { |doc| doc.current_due_amount }
        else
          @user_documents
        end
      else
        @user_documents
      end
    end
  end

  def create
    @user_document = UserDocument.new(user_document_params)
    authorize @user_document

    if current_or_guest_user.username == "guest"
      @user_document.user = guest_user
    else
      @user_document.user = current_user
    end

    if @user_document.save
      if @user_document.photo.metadata.nil?
        flash[:alert] = "Did you forget to upload your photo?"
        redirect_back fallback_location:
        @user_document.destroy
      else
        # UserDocumentMailer.creation_confirmation(@user_document).deliver_now
        api_data = VisionApi.detect_user_image(@user_document.photo.metadata["secure_url"])
        @document = find_document(api_data[:words])
        assign_data(@user_document, api_data)
        @user_document.save

        redirect_to user_document_path(@user_document), notice: 'Document was successfully created.'
      end
    else
      flash[:alert] = "You have errors!"
      render :index
    end
  end

  def show
    authorize @user_document
    # if current_or_guest_user.username == "guest"
    #   @user_document.user = guest_user
    # else
    #   @user_document.user = current_user
    # end
  end

  def pay
    authorize @user_document
    @user_document.state = true

    if @user_document.save
      respond_to do |format|
        format.html { redirect_to profile_path(@user) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'profiles/show' }
        format.js  # <-- idem
      end
    end
  end

  def unpaid
    authorize @user_document
    @user_document.state = false

    if @user_document.save
      respond_to do |format|
        format.html { redirect_to profile_path(@user) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'profiles/show' }
        format.js  # <-- idem
      end
    end
  end

  def update
    if current_or_guest_user.username == "guest"
      @user = guest_user
    else
      @user = current_user
    end

    @old_date = @user_document.reminder_date
    @user_document.update(user_document_params)
    authorize @user_document
    if @user_document.save
      respond_to do |format|
        format.js  # <-- will render `app/views/reviews/create.js.erb`
        format.html { redirect_to profile_path(@user) }
      end
    else
      respond_to do |format|
        format.html { render 'profiles/show' }
        format.js  # <-- idem
      end
    end
    # if @user_document.save && @old_date != @user_document.reminder_date
    #   UserDocumentMailer.creation_confirmation(@user_document).deliver_now
    #   redirect_back fallback_location: user_document_path(@user_document)
    # else
    #   redirect_back fallback_location: user_document_path(@user_document)
    # end
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

    Document.find_by(jp_name: doc_to_add)
  end

  def set_user_document
    @user_document = UserDocument.find(params[:id])
  end

  def user_document_params
    params.require(:user_document).permit(
      :title,
      :photo,
      :photo_cache,
      :doc_type,
      :due_date,
      :remaining_balance,
      :current_due_amount,
      :reminder_date,
      :state
    )
  end
end
