class WelcomeController < ApplicationController
  #before_action :authenticate_user!
	before_filter :restrict_user
  def index
    if current_user.present?
      if current_user.is_user?
        @reviewers = User.where(:user_type => 2).limit(3)
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end
