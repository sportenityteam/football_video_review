class ContactUsController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @contact_us = ContactU.new
  end 

  def contact_us_mail
    @contact_us = ContactU.new(contact_us_params)
    @contact_us.save
    @admin_user = User.where(:user_type => 1)
    @admin_user.each do |admin|
      ContactUsMailer.send_inquiry_email(@contact_us,admin).deliver_now!
    end
    respond_to do |format|
      format.html { redirect_to contact_us_mail_path, notice: 'Message send successfully.' }
      format.json { head :no_content }
    end
  end

  private
    def contact_us_params
      params.require(:contact_u).permit(:subject, :email, :description)
    end
end
