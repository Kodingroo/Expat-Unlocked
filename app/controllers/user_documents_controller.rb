class UserDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :create]

  def index
    VisionApi.new
  end

  def create
    VisionApi.new
  end
end
