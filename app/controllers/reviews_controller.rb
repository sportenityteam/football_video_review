class ReviewsController < ApplicationController
  before_action :set_order, :only => [:new]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @order = Order.find(params[:review][:order_id])
    review_time = params[:review][:review_time].present? ? ((params[:review][:submit_time].to_datetime - params[:review][:review_time].to_datetime) * 1.days) : 0

    @review.review_time = review_time
    respond_to do |format|
      if @review.save
        if params[:commit] == "Approve"
          @review.update_attributes(:status => "Approve")
          @order.update_attributes(:status => Order::STATUS["Review approved"])
        elsif params[:commit] == "Reject"
          @review.update_attributes(:status => "Reject")
          @order.update_attributes(:status => Order::STATUS["Review rejected"])
        end
        format.html { redirect_to reviews_path, notice: 'Review for video was submitted successfully.' }
        format.json { render :pending_reviews , status: :created, location: @review }
      else
        format.html { redirect_to review_order_path(@order), :notice => "#{@review.errors.full_messages.join(' , ')}" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def index
    @reviews = Review.where("reviewer_id =?", current_user.id)
  end

  def pending_reviews
    #@orders = Order.where(:status => Order::STATUS["Admin Approved/Waiting for review"])
    @orders = Order.where("status =? or status =?",Order::STATUS["Admin Approved/Waiting for review"], Order::STATUS["Review rejected"])
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def review_params
      params.require(:review).permit(:order_id, :reviewer_id, :technical_notes, :tactical_notes, :review_time)
    end
end
