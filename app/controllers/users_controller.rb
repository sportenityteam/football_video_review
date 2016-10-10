class UsersController < ApplicationController
  #before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  # to change password of logged in user
  def edit_change_password
    @user =  current_user
  end

  def change_password
    if params[:user][:current_password].present? && params[:user][:password].present?
      if current_user.update_with_password(change_password_params)
        sign_in(current_user, bypass_sign_in: true)
        redirect_to root_path, :notice => "Password updated successfully."
      else
        flash.now[:alert] = current_user.errors.full_messages.uniq
        render :edit
      end
    else
      if !params[:user][:current_password].present?
        flash.now[:alert] = "Current password can't be blank."
      elsif
        flash.now[:alert] = "New password can't be blank."
      end
      #flash.now[:alert] = current_user.errors.full_messages.uniq
      render :edit_change_password
    end
  end

  private
    def change_password_params
     params.require(:user).permit(:current_password,:password,:password_confirmation)
    end
end
