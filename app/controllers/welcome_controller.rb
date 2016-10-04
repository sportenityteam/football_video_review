class WelcomeController < ApplicationController
	before_filter :restrict_user
  def index
  end
end
