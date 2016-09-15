class OrdersController < ApplicationController
  before_action :set_order, :only => [:edit,:destroy]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :description, videos_attributes: [:duration, :description, :video_url])
    end
end
