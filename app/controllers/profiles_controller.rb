class ProfilesController < ApplicationController
  before_action :set_user, only: [:show]
  skip_after_action :verify_authorized

  def show
    # authorize @user
    skip_authorization
    @user_documents = UserDocument.where(user_id: current_user)
    @user_document = UserDocument.new
    @documents = Document.all

    @sort_by = ["due date", "most expensive", "least expensive"]
    @categories = []
    @collection_type = params[:sort_by]

    if @user_documents.exists?
      @user_documents.each do |doc|
        @categories << doc.document.company_name
      end

      @categories.uniq!
      @collection_type = params[:sort_by]

      @user_documents = @user_documents.reject { |doc| doc.document.company_name != params[:category] }

      @user_documents = if params[:sort_by] == "due date"
                          @user_documents.sort_by { |doc| doc.due_date }
                        elsif params[:sort_by] == "most expensive"
                          @user_documents.sort_by { |doc| -doc.current_due_amount }
                        elsif params[:sort_by] == "least expensive"
                          @user_documents.sort_by { |doc| doc.current_due_amount }
                        else
                          @user_documents
                        end
    end
  end

  def update
    authorize @user
    @user.update(user_params)
  end

  def update
    authorize @user
    @user.update(user_params)

    if @user.save
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

  def set_user
    @user = current_user
  end
end
