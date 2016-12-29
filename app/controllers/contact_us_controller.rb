class ContactUsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def new
    @contact_us = ContactU.new
  end

  def contact_us_mail
    @contact_us = ContactU.new(contact_us_params)
    if params[:contact_u][:email].present?
      @contact_us.save
      @admin_user = User.where(:user_type => 1)
      @admin_user.each do |admin|
        ContactUsMailer.send_inquiry_email(@contact_us,admin).deliver_now!
      end
      respond_to do |format|
        format.html { redirect_to contact_us_mail_path, notice: 'Message send successfully.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to contact_us_mail_path, notice: 'Please enter your email address.' }
        format.json { head :no_content }
      end
    end
  end

  def about
  end

  def faq
  end

  private
    def contact_us_params
      params.require(:contact_u).permit(:subject, :email, :description)
    end
end
