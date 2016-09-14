class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :set_layout

  #Setting different layout for different user
  private
    def set_layout
      if user_signed_in?
        if current_user.is_admin?
          "admin"
        elsif current_user.is_user?
          "user"
        elsif current_user.is_reviewer?
          "reviewer"
        end
      end
    end

  protected
    # configuring registration parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :gender, :date_of_birth, :position, :zipcode])
      #devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :gender, :date_of_birth, :position, :zipcode])
    end
end
