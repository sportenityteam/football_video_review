class UserMailer < ActionMailer::Base

  default from: "from@example.com"

  def send_new_user_message(user)
    @user = user
    mail(:to => @user.email , :subject => "Football Video Review : confirmation")
  end

end
