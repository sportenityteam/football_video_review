class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :restrict_admin

  protected
    def restrict_admin
      if user_signed_in?
        if current_user.is_user?
          redirect_to root_url
        elsif current_user.is_reviewer?
          redirect_to root_url
        end
      end
    end
end
