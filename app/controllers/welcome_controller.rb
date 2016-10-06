class WelcomeController < ApplicationController
	before_filter :restrict_user
  def index
    @reviewers = User.where(:user_type => 2).limit(3)
  end
end
