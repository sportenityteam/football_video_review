class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :set_dob ,only: [:create,:update]
  # GET /resource/sign_up
  def new
    @user = User.new(:date_of_birth => "2004-08-01".to_date)
    super
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    unless params[:user][:current_password] == ""
      respond_to do |format|
        if resource.update_with_password(user_password_params)
          format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    else
      respond_to do |format|
        if resource.update_without_password(user_params)
          format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode, :user_type, :avatar, :current_club,:address,:description])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode,:avatar,:current_club,:address,:description,:phone_number, :password, :password_confirmation, :current_password])
  end

  # The path used after update profile
  def after_update_path_for(resource)
    my_profile_path#(resource)
  end

  def user_params
    params.require(:user).permit(:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode,:avatar,:current_club,:address,:description,:phone_number)
  end

  def user_password_params
    params.require(:user).permit(:soccer_club, :soccer_goal, :first_name, :last_name, :gender, :date_of_birth, :position, :zipcode,:avatar,:current_club,:address,:description,:phone_number,:password, :password_confirmation, :current_password)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

    # def update_resource(resource, params)
    #   resource.update_without_password(params)
    # end
  private

  def set_dob
    #params[:user][:date_of_birth] = DateTime.strptime(params[:user][:date_of_birth], "%m-%d-%Y") if params[:user][:date_of_birth].present?
    params[:user][:date_of_birth] = Date.new(params[:user]["date_of_birth(1i)"].to_i,params[:user]["date_of_birth(2i)"].to_i,params[:user]["date_of_birth(3i)"].to_i)
  end
end
