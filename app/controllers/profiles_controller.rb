class ProfilesController < ApplicationController
  before_action :set_user, only: [ :show ]
  skip_after_action :verify_authorized

  def show
    # authorize @user
    skip_authorization
    @user_documents = UserDocument.all

    @collection_type = params["/profile.#{@user.id}"][:query] if params["/profile.#{@user.id}"]
    if @collection_type == 'due date'
      date_query = "SELECT * FROM user_documents ORDER BY due_date DESC"
      @user_documents = UserDocument.find_by_sql(date_query)
    elsif @collection_type == 'most expensive'
      expensive_query = "SELECT * FROM user_documents ORDER BY current_due_amount DESC"
      @user_documents = UserDocument.find_by_sql(expensive_query)
    elsif @collection_type == 'least expensive'
      cheap_query = "SELECT * FROM user_documents ORDER BY current_due_amount ASC"
      @user_documents = UserDocument.find_by_sql(cheap_query)
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

