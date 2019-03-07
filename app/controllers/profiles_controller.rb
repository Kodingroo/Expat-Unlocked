class ProfilesController < ApplicationController
  before_action :set_user, only: [ :show ]
  skip_after_action :verify_authorized

  def show
    # authorize @user
    skip_authorization
    @user_documents = UserDocument.all

    @categories = []
    if @user_documents.exists?

      @user_documents.each do |doc|
        @categories << doc.document.company_name
      end

      @categories.uniq!
      # @categories.reject! { |cat| cat == params[:category] }.uniq!
      # raise
      # @filter = @user_documents.find_all{ |doc| doc.document[:company_name].include?(@categories) }

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
      # if @categories == @user_documents.document.company_name
      #   @collection_type = params["/profile.#{@user.id}"][:query] if params["/profile.#{@user.id}"]
      #   if @collection_type == 'due date'
      #     date_query = "SELECT * FROM user_documents ORDER BY due_date DESC"
      #     @user_documents = UserDocument.find_by_sql(date_query)
      #   elsif @collection_type == 'most expensive'
      #     expensive_query = "SELECT * FROM user_documents ORDER BY current_due_amount DESC"
      #     @user_documents = UserDocument.find_by_sql(expensive_query)
      #   elsif @collection_type == 'least expensive'
      #     cheap_query = "SELECT * FROM user_documents ORDER BY current_due_amount ASC"
      #     @user_documents = UserDocument.find_by_sql(cheap_query)
      #   else
      #     @user_documents = UserDocument.all
      #   end
      # end
    end

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

