class UserMailer < ActionMailer::Base
  default from: "support@sportenity.com"

  def send_new_user_password(user,pass)
    @user = user
    @password = pass
    mail(:to => @user.email , :subject => "Soccer Video Review : Password Information")
  end

end
