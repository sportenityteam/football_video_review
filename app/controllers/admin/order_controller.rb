class Admin::OrderController < ApplicationController

  before_action :set_order, :only => [:show]

  def index
    @orders = Order.where(:status => Order::STATUS["New"])
  end

  def show
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

end
