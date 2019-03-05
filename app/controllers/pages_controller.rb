class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @user_document = UserDocument.new
  end
end
