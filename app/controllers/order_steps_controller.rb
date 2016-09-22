class OrderStepsController < ApplicationController

  include Wicked::Wizard
  steps :add_order, :add_payment
  before_action :set_variables

  def show
    case step
      when :add_order
        @order.videos.build if @order.present?
        render_wizard
      when :add_payment
        render_wizard
    end
  end

  def update
    @total_duration = 0
    @errors = ''
    case step
      when :add_order
        @order.update_attributes(order_params)
        if @order.errors.present?
          render_wizard
        else
          if @order.videos.present?
            @order.videos.each do |video|
              video.generate_mp4(video)
              @total_duration = @total_duration + video.duration.to_i
            end
          end
          @order.update_attributes(:total_video_duration => @total_duration,:user_id => current_user.id)
          $orderId = @order.id
          render_wizard @order
        end
      when :add_payment
        response = place_order(@amount, params[:card_number], params[:expiration_month], params[:expiration_year], params[:cvv])
        if response != false
          if response.success?
            #creating record of payment for placed order
            @payment.update_attributes(:order_id => $orderId,:amount => @amount,:date_of_payment => DateTime.now, :other_data => response.params ,:status => "success",:transcation_id => response.params["pn_ref"])
            redirect_to orders_path(:type => "New")
          else
            @errors = response.message
            render_wizard
          end
        else
          @errors = "Please fill the card details"
          render_wizard
        end
    end
  end

  #Placing order through Payflow gateway on PayPal
  def place_order(amount, card_number, expiration_month, expiration_year, cvv)
    if card_number.present? && expiration_month.present? && expiration_year.present? && cvv.present?
      @credit_card = Payment.validate_credit_card(current_user.try(:first_name),current_user.try(:last_name),card_number,expiration_month,expiration_year,cvv)
      response = GATEWAY.purchase(amount, @credit_card)
      return response
    else
      return false
    end
  end


  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :description, videos_attributes: [:duration, :description, :video_url,:id,:_destroy])
    end

    def set_variables
      @order = Order.new
      @payment = Payment.new
      @amount = User.calculate_amount_from_age(current_user.date_of_birth.strftime("%m/%d/%Y"))
    end
end
