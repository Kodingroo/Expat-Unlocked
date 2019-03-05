class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]
  before_action :authenticate_user!

  def index
  end

  def create
    # The user image will be passed through this method
    # The method will hit the api and get the required data
    # TODO: Get all japanese text. Translate text.
    # VisionApi.detect_user_image(image)


    # FOR REMINDER EMAILS
    # @user = current_user.build(user_params)
    # UserDocumentMailer.reminder(@user).deliver_now
  end

  def show
  end

  def update
  end

end
