class ContactUsMailer< ActionMailer::Base
  default from: "hello@sportenity.com"

  def send_inquiry_email(contact_us,admin)
  	@message_body = contact_us.description
    @email = contact_us.email
    @subject = contact_us.subject.present? ? contact_us.subject : "Football Video Review: Inquiry"
    mail(:to => admin.email , :subject => @subject,:reply_to => contact_us.email)
  end
end
