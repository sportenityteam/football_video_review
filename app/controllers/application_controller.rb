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

    #redirection of different users after sign in
    def after_sign_in_path_for(resource)
      puts "==========resource========#{resource.inspect}======="
      if resource.is_admin?
        return admin_pending_orders_path 
      elsif resource.is_reviewer?
        return pending_reviews_path 
      else
        return orders_path 
      end 
    end

  protected
    # configuring registration parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :gender, :date_of_birth, :position, :zipcode, :user_type])
      #devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :gender, :date_of_birth, :position, :zipcode])
    end

    def restrict_user 
      if user_signed_in?
        if current_user.is_admin?
          redirect_to root_url
        elsif current_user.is_reviewer?
          redirect_to root_url
        end
      end
    end
end
