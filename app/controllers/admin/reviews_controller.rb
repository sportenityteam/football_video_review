class Admin::ReviewsController < Admin::BaseController

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @order = Order.find(params[:review][:order_id])
    review_time = params[:review][:review_time].present? ? ((params[:submit_time].to_datetime - params[:review][:review_time].to_datetime) * 1.days) : 0

    @review.review_time = review_time
    respond_to do |format|
      if @review.save
        if params[:commit] == "Approve"
          @review.update_attributes(:status => "Approve")
          @order.update_attributes(:status => Order::STATUS["Admin Approved"])
          OrderMailer.admin_approved_order(@order).deliver_now
        elsif params[:commit] == "Reject"
          @review.update_attributes(:status => "Reject")
          @order.update_attributes(:status => Order::STATUS["Admin rejected"])
          OrderMailer.admin_rejected_order(@order).deliver_now
        end
        format.html { redirect_to admin_pending_orders_path, notice: 'Review for video was submited successfully.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { redirect_to admin_review_order_path(@order), :notice => "#{@review.errors.full_messages.join(' , ')}" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @review = Review.joins(:user).where("users.user_type != ? and reviews.order_id = ? " ,3,params[:id]).last
  end

  def destroy
    @review = Review.where("order_id =? and user_id !=?", params[:id], current_user.id)
    @review.destroy_all
    @order = Order.find(params[:id])
    @order.update_attributes(:status => Order::STATUS["Admin Approved"])
    respond_to do |format|
      format.html { redirect_to admin_reviewed_by_reviewer_path, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def review_params
      params.require(:review).permit(:order_id, :user_id, :technical_notes, :tactical_notes, :review_time)
    end

end
