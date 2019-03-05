class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]
  # before_action :authenticate_user!

  def index
    VisionApi.detect_user_image("https://www7.tepco.co.jp/wp-content/uploads/sites/2/ep02-01-000-img02.gif")
  end

  def create
    # The user image will be passed through this method
    # The method will hit the api and get the required data
    # TODO: Get all japanese text. Translate text.
    # VisionApi.detect_user_image(image)
  end

  def show
  end

  def update
  end
end
