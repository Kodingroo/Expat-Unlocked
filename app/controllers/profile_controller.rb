class ProfileController < ApplicationController
  skip_after_action :verify_authorized

  def show
  end
end
