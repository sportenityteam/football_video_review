class ContactUsMailer< ActionMailer::Base
  default from: "support@sportenity.com"

  def send_inquiry_email(contact_us,admin)
  	@message_body = contact_us.description
    @email = contact_us.email
    @subject = contact_us.subject.present? ? contact_us.subject : "Soccer Video Review: Inquiry"
    mail(:to => "support@sportenity.com" , :subject => @subject,:reply_to => contact_us.email)
  end
end
