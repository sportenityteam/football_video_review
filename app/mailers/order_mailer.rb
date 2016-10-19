class OrderMailer < ActionMailer::Base

  default from: "support@sportenity.com"

  def send_new_order_message(order,user)
    @user = user
    @order = order
    mail(:to => @user.email , :subject => "Soccer Video Review : New Video for Review")
  end

  def send_new_order_mail_to_admin(order,user)
    @user = user
    @order = order
    mail(:to => @user.email , :subject => "Soccer Video Review : New Video")
  end

  def send_new_order_mail_to_user(order,user)
    @user = user
    @order = order
    mail(:to => @user.email , :subject => "Soccer Video Review : New Video Uploaded")
  end

  def send_new_order_mail_to_reviewer(order,user)
    @user = user
    @order = order
    mail(:to => @user.email , :subject => "Soccer Video Review : New Video for Review")
  end

  def admin_approved_order(order)
    @order = order
    mail(:to => @order.user.email , :subject => "Soccer Video Review : Admin Approved Video")
  end

  def admin_rejected_order(order)
    @order = order
    mail(:to => @order.user.email , :subject => "Soccer Video Review : Admin Rejected Video")
  end

  def reviewed_order(order,user)
    @order = order
    @user = user
    mail(:to => @user.email , :subject => "Soccer Video Review : Video Reviewed")
  end

  def admin_review_approved(order)
    @order = order
    mail(:to => @order.user.email , :subject => "Soccer Video Review : Video Review Approved")
  end

  def admin_review_rejected(order, reviewer)
    @order = order
    @user = reviewer
    mail(:to => @user.email , :subject => "Soccer Video Review : Video Review Rejected")
  end

end
