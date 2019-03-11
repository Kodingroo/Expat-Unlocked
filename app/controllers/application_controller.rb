class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery :except => :receive_guest
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_or_guest_user
  skip_before_filter :verify_authenticity_token, :only => [:update]


  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:index,:show], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end
  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :address])
    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:address, :photo, :first_name, :last_name]
    )
  end
  # ---------------------------------------GUEST>>>>>>>>>>>>>>>>>>>>>>>
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
    rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    guest_user_documents = guest_user.user_documents.all
    guest_user_documents.each do |user_document|
      user_document.user_id = current_user.id
      user_document.save!
    end
  end

  def create_guest_user
    u = User.new(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

  # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<------------GUEST
  # private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
