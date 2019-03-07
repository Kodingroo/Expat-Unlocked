class ProfilesController < ApplicationController
  before_action :set_user, only: [ :show ]
  skip_after_action :verify_authorized

  def show
    # authorize @user
    skip_authorization
    @user_documents = UserDocument.all

    if params[:query] == 'due date'
      @collection_type = params[:query]
      date_query = "SELECT * FROM user_documents ORDER BY due_date DESC ILIKE :query"
      @user_documents = UserDocument.where(date_query, query: "%#{params[:query]}%")
    elsif params[:query] == 'most expensive'
      @collection_type = params[:query]
      expensive_query = "SELECT * FROM user_documents ORDER BY current_due_amount DESC ILIKE :query"
      @user_documents = UserDocument.where(expensive_query, query: "%#{params[:query]}%")
    else
     @user_documents = UserDocument.all
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

