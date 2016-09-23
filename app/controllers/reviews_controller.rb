class ReviewsController < ApplicationController

  before_action :set_order, :only => [:new]
  before_action :set_review, :only => [:show]

  def new
    @review_new = Review.where(:order_id => @order.id, :user_id => current_user.id).first
    @review = Review.new
    if @order.status == 7 and !@review_new.present?
      redirect_to pending_reviews_path, notice: "Video Already reviewed by other reviewer."
    else
      Review.find_or_create_by(:order_id => @order.id, :user_id => current_user.id)
      @order.update_attributes(:status => Order::STATUS["In review"])
    end
  end

  def create
    @review = Review.find_or_initialize_by(:order_id => params[:review][:order_id], :user_id => params[:review][:user_id])

    @review.technical_notes = params[:review][:technical_notes]
    @review.tactical_notes = params[:review][:tactical_notes]

    @order = Order.find(params[:review][:order_id])
    review_time = params[:review][:review_time].present? ? ((params[:submit_time].to_datetime - params[:review][:review_time].to_datetime) * 1.days) : 0

    @review.review_time = review_time
    respond_to do |format|
      if @review.save
        if params[:is_reviewed] == "1"
          @order.update_attributes(:status => Order::STATUS["Reviewed"])
          @user = User.is_admin.first
          OrderMailer.reviewed_order(@order,@user).deliver_now
          format.html { redirect_to my_reviews_path, notice: 'Review for video was submitted successfully.' }
          format.json { render :pending_reviews , status: :created, location: @review }
        else
          format.html { redirect_to review_order_path(@order), notice: 'Review notes saved successfully.' }
          format.json { render :pending_reviews , status: :created, location: @review }
        end
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

  def update
  end

  def index
    @reviews = Review.where("user_id =?", current_user.id)
    #@reviews = Review.joins(:order).where("reviews.user_id =? and orders.status != ?", current_user.id, 7)
  end

  def pending_reviews
    order_ids = Review.joins(:order).where("orders.status =? or orders.status =? or orders.status =? and reviews.user_id =? ",Order::STATUS["Admin Approved"], Order::STATUS["Review rejected"], Order::STATUS["In review"], current_user.id).pluck(:order_id).uniq
    @orders = Order.where("id IN (?)", order_ids)
  end

  def destroy
    @review = Review.where("order_id =? and user_id =?", params[:id], current_user.id)
    @review.destroy_all
    @order = Order.find(params[:id])
    @order.update_attributes(:status => Order::STATUS["Admin Approved"])
    respond_to do |format|
      format.html { redirect_to pending_reviews_path, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def set_review
      @review = Review.find(params[:id])
    end
    def review_params
      params.require(:review).permit(:order_id, :user_id, :technical_notes, :tactical_notes, :review_time)
    end
end
