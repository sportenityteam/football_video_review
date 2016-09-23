class OrdersController < ApplicationController
  before_action :set_order, :only => [:edit,:destroy,:show]
  before_action :restrict_user

  def new
    @order = Order.new
    @order.videos.build
    @amount = User.calculate_amount_from_age(current_user.date_of_birth.strftime("%m/%d/%Y"))
  end

  def create
    @order = Order.new(order_params)
    @total_duration = 0
    respond_to do |format|
      #fetching amount for placing order from calculate_amount_from _age method
      @amount = User.calculate_amount_from_age(current_user.date_of_birth.strftime("%m/%d/%Y"))
      #setting response of place_order if resonse is sucess then order will be saved
      response = place_order(@amount)
      if response != false
        if response.success?
          puts "Successfully charged $#{@amount} to the credit card #{@credit_card.number}"
          if @order.save
            if @order.videos.present?
              @order.videos.each do |video|
                video.generate_mp4(video)
                @total_duration = @total_duration + video.duration.to_i
              end
            end
            @order.update_attributes(:total_video_duration => @total_duration,:user_id => current_user.id)

            #creating record of payment for placed order
            @payment = Payment.new(:order_id => @order.id,:amount => @amount,:date_of_payment => DateTime.now, :other_data => response.params ,:status => "success",:transcation_id => response.params["pn_ref"])
            @payment.save

            format.html { redirect_to my_orders_path, notice: 'Order was successfully created.' }
            format.json { render :show, status: :created, location: @order }
          else
            format.html { render :new }
            format.json { render json: @order.errors, status: :unprocessable_entity }
          end
        else
          flash[:notice] = response.message
          format.html { render :new }
        end
      else
        flash[:notice] = "Please fill the card details"
        format.html { render :new }
      end
    end
  end

  def show
    @reviewer = Review.joins(:user).where("reviews.order_id =? and users.user_type != ?", @order.id, 1).last
  end

  def edit
  end

  def update
  end

  def index
    @orders = Order.where(:user_id => current_user.id, :status => Order::STATUS[params[:type]])
  end

  def my_orders
    @orders = Order.where("user_id =? and status =? or status =? or status =? ", current_user.id, Order::STATUS["Pending"], Order::STATUS["Review approved"], Order::STATUS["In review"])
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Placing order through Payflow gateway on PayPal
  def place_order(amount)
    if params[:card_number].present? && params[:expiration_month].present? && params[:expiration_year].present? && params[:cvv].present?
      @credit_card = Payment.validate_credit_card(current_user.try(:first_name),current_user.try(:last_name),params[:card_number],params[:expiration_month],params[:expiration_year],params[:cvv])
      response = GATEWAY.purchase(amount, @credit_card)
      return response
    else
      return false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :description, videos_attributes: [:duration, :description, :video_url,:id,:_destroy])
    end
end
