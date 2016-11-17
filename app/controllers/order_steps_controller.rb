class OrderStepsController < ApplicationController

  include Wicked::Wizard
  steps :add_payment, :add_order
  before_action :authenticate_user!
  before_action :set_variables
  before_filter :restrict_user

  def show
    case step
      when :add_payment
        render_wizard
      when :add_order
        @order.videos.build #if @order.present?
        render_wizard
    end
  end

  def update
    @total_duration = 0
    @errors = ''
    case step
      when :add_payment
        # if params[:order_id].present?
        #   $orderId = params[:order_id]
        # end
        #@amount = User.calculate_amount_from_age(current_user.date_of_birth.strftime("%m/%d/%Y"))
        @amount = params[:price].to_i
        response = place_order(@amount, params[:card_number], params[:expiration_month], params[:expiration_year], params[:cvv])
        if response != false
          if response.success?
            $is_payment = true
            #creating record of payment for placed order
            $transactionId = response.params["pn_ref"]
            @payment.update_attributes(:amount => @amount,:date_of_payment => DateTime.now, :other_data => response.params ,:status => "success",:transcation_id => response.params["pn_ref"], :user_id => current_user.id)
            #redirect_to my_orders_path
            render_wizard @payment
          else
            @flag = 0
            @errors = response.message
            render_wizard
          end
        else
          flash[:alert] = "Please fill the card details"
          render_wizard
        end
      when :add_order
        if $is_payment == true
          logger.warn("=-=-=--=-==-----------------in if")
          logger.warn(@order.errors.inspect)
          logger.warn("=-=-=--=-==-----------------")
          if @order.errors.present?
            render_wizard
          else

            if @order.update_attributes(order_params)
              @order.update_attributes(:user_id => current_user.id)
              logger.warn("=--=Order=-=-=-=-=-=-=-=-=-#{@order.inspect}=--=")
              if @order.videos.present?
                @order.videos.each do |video|
                  video.generate_mp4(video.video_url)
                  @total_duration = @total_duration + video.duration.to_i
                end
              end
              @order.update_attributes(:payment_status => "paid")
              Order.send_admin_reviewer_mail(@order)
              payment = Payment.find_by_transcation_id($transactionId)
              if payment.present?
                payment.update_attributes(:order_id => @order.id, :order_status => "completed")
              else
                order_id = current_user.orders.last.id
                payment.update_attributes(:order_id => order_id, :order_status => "completed")
              end
              $is_payment = false
              flash[:notice] = "Thank you! Your upload is complete. You will be notified via email once the review is ready."
              redirect_to my_orders_path
            else
              render_wizard
            end
          end
        elsif current_user.payments.last.order_status == nil
          logger.warn("=--=Payment=-=-=-=-=-=-=-=-=-#{current_user.payments.last.inspect}=--=")
          if @order.update_attributes(order_params)
            @order.update_attributes(:user_id => current_user.id)
            logger.warn("=--=Order=-=-=-=-=-=-=-=-=-#{@order.inspect}=--=")
            if @order.videos.present?
              @order.videos.each do |video|
                video.generate_mp4(video.video_url)
                @total_duration = @total_duration + video.duration.to_i
              end
            end
            @order.update_attributes(:payment_status => "paid")
            Order.send_admin_reviewer_mail(@order)
            payment = Payment.find_by_transcation_id($transactionId)
            if payment.present?
              payment.update_attributes(:order_id => @order.id, :order_status => "completed")
            else
              order_id = current_user.orders.last.id
              current_user.payments.last.update_attributes(:order_id => order_id, :order_status => "completed")
            end
            $is_payment = false
            flash[:notice] = "Thank you! Your upload is complete. You will be notified via email once the review is ready."
            redirect_to my_orders_path
          else
            render_wizard
          end
        else
          $is_payment = false
          redirect_to order_step_path(:add_payment)
          flash[:alert] = "You need to do payment first for upload videos."
        end
    end
  end

  #Placing order through Payflow gateway on PayPal
  def place_order(amount, card_number, expiration_month, expiration_year, cvv)
    if card_number.present? && expiration_month.present? && expiration_year.present? && cvv.present?
      @credit_card = Payment.validate_credit_card(current_user.try(:first_name),current_user.try(:last_name),card_number,expiration_month,expiration_year,cvv)
      #updated code
      @user = current_user
      requested_ip = request.remote_ip
      #add one extra parameter
      response = GATEWAY.purchase(amount, @credit_card,Payment.purchase_options(@user,requested_ip))
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
      @amount_12 = Price.find_by_name("U12 and under").price
      @amount_13 = Price.find_by_name("U13 and over").price
    end
end
