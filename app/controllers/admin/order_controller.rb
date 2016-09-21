class Admin::OrderController < Admin::BaseController

  before_action :set_order, :only => [:show,:order_details]

  def index
    @orders = Order.where(:status => Order::STATUS["New"])
  end

  def reviewed_videos
    order_ids = Review.where("user_id =?", current_user.id).pluck(:order_id).uniq
    @orders = Order.where("id IN (?)", order_ids)
  end

  def show
    @review = Review.new
  end

  def reviewed_by_reviewer
    @orders = Order.where(:status => Order::STATUS["Reviewed"])
  end

  # if admin approve or reject any order then order status will be updated
  def approval_of_admin
    status = params[:status]
    @order = Order.find(params[:id])
    @order.update_attributes!(:status => status)
    @order_email = Order.find(params[:id])
    if status == "5"
      OrderMailer.admin_review_approved(@order_email).deliver_now
    elsif status == "6"
      @reviewer = @order.reviews.last.user
      OrderMailer.admin_review_rejected(@order_email,@reviewer).deliver_now
    end
    redirect_to admin_reviewed_by_reviewer_path , :notice => "Order successfully updated."
  end

  #List of orders
  def list_of_orders
    @orders = Order.all
  end

  def order_details
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

end
