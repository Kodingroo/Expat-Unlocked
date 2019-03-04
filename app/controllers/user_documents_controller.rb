class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]

  def index
  end

  def create
    # The user image will be passed through this method
    # The method will hit the api and get the required data
    # TODO: Get all japanese text. Translate text.
    # VisionApi.detect_user_image(image)
  end
end
