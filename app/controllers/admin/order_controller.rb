class Admin::OrderController < Admin::BaseController

  before_action :set_order, :only => [:show]

  def index
    @orders = Order.where(:status => Order::STATUS["New"])
  end

  def reviewed_videos
    @reviews = Review.where("user_id =?", current_user.id)
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
    redirect_to admin_reviewed_by_reviewer_path , :notice => "Order successfully updated."
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

end
