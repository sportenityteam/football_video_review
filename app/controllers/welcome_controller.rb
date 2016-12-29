class WelcomeController < ApplicationController
  before_action :authenticate_user!
	before_filter :restrict_user
  def index
    if current_user.present?
      if current_user.is_user?
        @reviewers = User.where(:user_type => 2).limit(3)
      elsif current_user.is_reviewer?
        redirect_to pending_reviews_path
      elsif current_user.is_admin?
        redirect_to admin_dashboard_path
      end
    else
      redirect_to new_user_registration_path
    end
  end
end
