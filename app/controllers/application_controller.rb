class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
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
      else
        "devise"
      end
    end

    #redirection of different users after sign in
    def after_sign_in_path_for(resource)
      if resource.is_admin?
        return admin_dashboard_path
      elsif resource.is_reviewer?
        return pending_reviews_path
      else
        #return orders_path(:type => "Pending")
        return my_orders_path
      end
    end

  protected
    # configuring registration parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode, :user_type, :current_club,:address,:description])
      devise_parameter_sanitizer.permit(:account_update, keys: [:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode , :current_club, :address, :description, :phone_number, :password, :password_confirmation, :current_password])
    end

    def restrict_user
      if user_signed_in?
        if current_user.is_admin?
          redirect_to admin_dashboard_path
        elsif current_user.is_reviewer?
          redirect_to root_url
        end
      end
    end
end
