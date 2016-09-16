class OrdersController < ApplicationController
  before_action :set_order, :only => [:edit,:destroy]
  before_action :restrict_user

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
    @order.videos.build
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @total_duration = 0
    respond_to do |format|
      amount = 1000
      #setting response of place_order if resonse is sucess then order will be saved
      response = place_order(amount)
      puts "====response==========#{@response.inspect}========"
      if response.success?
        puts "=======inside success========="
        puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{@credit_card.number}"
        if @order.save
          if @order.videos.present?
            @order.videos.each do |video|
              video.generate_mp4(video)
              @total_duration = @total_duration + video.duration.to_i
            end
          end
          @order.update_attributes(:total_video_duration => @total_duration)
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
         raise StandardError, response.message
      end
    end
  end

  def update
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
    @credit_card = Payment.validate_credit_card("Krupali","Makwana","4111111111111111","9","2017","123","visa")
    if @credit_card.valid?
      response = GATEWAY.purchase(amount, @credit_card)
      puts "=========amount=====#{amount}=====creditcard=====#{@credit_card.inspect}======="
      return response
    else
      puts "====errors========#{@credit_card.errors.full_messages}"
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :description, videos_attributes: [:duration, :description, :video_url])
    end
end
