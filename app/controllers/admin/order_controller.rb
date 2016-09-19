class Admin::OrderController < Admin::BaseController

  before_action :set_order, :only => [:show]

  def index
    @orders = Order.where(:status => Order::STATUS["New"])
  end

  def reviewed_videos
    @reviews = Review.where("user_id =?", current_user.id)
  end

  def show
    @order.update_attributes(:status => Order::STATUS["In review"])
    Review.find_or_create_by(:order_id => @order.id, :user_id => current_user.id)
    @review = Review.new
  end

  def reviewed_by_reviewer
    @orders = Order.where(:status => Order::STATUS["Reviewed"])
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

end
