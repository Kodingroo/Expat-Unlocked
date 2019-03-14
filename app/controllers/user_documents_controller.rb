class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :show]
  protect_from_forgery :except => :receive_guest
  before_action :set_user_document, only: [:show, :update, :pay, :unpaid, :destroy]
  # before_action :authenticate_user!

  def index
    @user_documents = policy_scope(UserDocument).order(created_at: :desc)
    @user_document = UserDocument.new

    @sort_by = ["Date Added", "Due Date", "Cost: High to Low", "Cost: Low to High"]
    @categories = ["All"]
    @collection_type = params[:sort_by] unless

    if @user_documents.exists?
      @user_documents.each do |doc|
        @categories << doc.document.company_name unless doc.document.nil?
      end

      @categories.uniq!
      @collection_type = params[:sort_by]

      if params[:category].nil? || params[:category].empty? || params[:category] == "All"
        @user_documents
      elsif params[:category] != "All"
        @user_documents = @user_documents.reject { |doc| doc.document.company_name != params[:category] }
      end

      if params[:sort_by] == "Date Added"
        @user_documents = @user_documents.sort_by { |doc| doc.due_date }
      elsif params[:sort_by] == "Due Date"
        @user_documents = @user_documents.sort_by { |doc| doc.due_date }
      elsif params[:sort_by] == "Cost: High to Low"
        @user_documents = @user_documents.sort_by { |doc| -doc.current_due_amount }
      elsif params[:sort_by] == "Cost: Low to High"
        @user_documents = @user_documents.sort_by { |doc| doc.current_due_amount }
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
        
        api_data = VisionApi.detect_user_image(@user_document.photo.metadata["secure_url"])
        p api_data
        @document = find_document(api_data[:words])
        # if @document.nil?
        #   flash[:alert] = "Sorry, but we don't recognize that bill yet"
        #   redirect_back fallback_location:
        #   @user_document.destroy
        # end
        assign_data(@user_document, api_data)
        @user_document.save
        # if current_or_guest_user.username != "guest"
        #   # UserDocumentMailer.creation_confirmation(@user_document).deliver_now
        # end
        redirect_to user_document_path(@user_document), notice: 'Document was successfully created.'
      end
    else
      flash[:alert] = "You have errors!"
      render :index
    end
  end

  def show
    # authorize @user_document
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
