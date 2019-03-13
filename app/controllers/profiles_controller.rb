class ProfilesController < ApplicationController
  before_action :set_user, only: [:show]
  skip_after_action :verify_authorized

  def show
    # authorize @user
    skip_authorization
    @user_documents = UserDocument.where(user_id: current_user.id)
    @user_document = UserDocument.new

    @documents = Document.all

    @general_stats = UserDocument.general_bills(current_user)
    @gas_stats = UserDocument.search_stats("Tokyo Gas", current_user)
    @electricity_stats = UserDocument.search_stats("Tokyo Electricity", current_user)
    @water_stats = UserDocument.search_stats("Tokyo Water", current_user)

    @sort_by = ["due date", "most expensive", "least expensive"]
    @categories = ["all"]
    @collection_type = params[:sort_by]

    unless params[:category]
      params[:category] = "all"
    end

    if @user_documents.exists?
      @user_documents.each do |doc|
        @categories << doc.document.company_name unless doc.document.company_name.nil?
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

  def gas_stats

  end

  def electricity_stats

  end

  def water_stats

  end

  def user_params
    params.require(:user).permit(:username)
  end

  def set_user
    @user = current_user
  end
end
