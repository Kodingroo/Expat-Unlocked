class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :scan_info]

  def home
    @user_document = UserDocument.new
  end

  def scan_info
    @user_document = UserDocument.new
  end
end
