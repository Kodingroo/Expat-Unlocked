class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :index]
  # before_action :authenticate_user!

  def index
    VisionApi.detect_user_image("https://resources.realestate.co.jp/wp-content/uploads/2018/09/Tenshutsu-Todoke-Notice-of-Moving-Out-Japan.png")
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
