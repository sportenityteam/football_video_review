class LandingPageController < ApplicationController
  before_filter :restrict_user
  def index
    if current_user.present?
      if current_user.is_user?
        redirect_to welcome_index_path
      end
    end
  end
end
