class Admin::ReviewsController < Admin::BaseController

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
          @order.update_attributes(:status => Order::STATUS["Admin Approved/Waiting for review"])
        elsif params[:commit] == "Reject"
          @order.update_attributes(:status => Order::STATUS["Admin rejected"])
        end
        format.html { redirect_to admin_pending_orders_path, notice: 'Review for video was submited successfully.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { redirect_to admin_review_order_path(@order), :notice => "#{@review.errors.full_messages.join(' , ')}" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def review_params
      params.require(:review).permit(:order_id, :reviewer_id, :technical_notes, :tactical_notes, :review_time)
    end

end
