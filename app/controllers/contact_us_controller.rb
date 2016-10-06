class ContactUsController < ApplicationController

  def contact_us_mail
    @contact_us = ContactU.new#(contact_us_params)
    @admin_user = User.where(:user_type => 1)
    @admin_user.all.each do |admin|
      ContactUsMailer.send_inquiry_email(@contact_us,admin)
    end
  end

  private
    def contact_us_params
      params.require(:contact_us).permit(:subject, :email, :description)
    end
end
