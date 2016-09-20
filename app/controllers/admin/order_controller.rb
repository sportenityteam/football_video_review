class Admin::OrderController < Admin::BaseController

  before_action :set_order, :only => [:show]

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
