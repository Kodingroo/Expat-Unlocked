class ProfileController < ApplicationController
  skip_after_action :verify_authorized

  def show
    # @cithyhall = current_user.near()
  end
end
