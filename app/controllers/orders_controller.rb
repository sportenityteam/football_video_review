class OrdersController < ApplicationController

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
    respond_to do |format|
      if @order.save
        if @order.videos.present?
          @order.videos.each do |video|
            video.generate_mp4(video,video.video_url)
          end
        end
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
  end

  private
    def order_params
      params.require(:order).permit(:title, :description, videos_attributes: [:duration, :description, :video_url])
    end
end
