class Admin::PricesController < Admin::BaseController

  #respond_to :html, :json
  before_action :set_price, :only => [:show,:destroy]

  def index
    @prices = Price.all
  end

  def show
  end

  def new
    @price = Price.new
  end

  def create
    @price = Price.new(price_params)
    respond_to do |format|
      if @price.save
        format.html { redirect_to admin_prices_path, :notice => 'Price was successfully added.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @price = Price.find params[:id]
    respond_to do |format|
      if @price.update_attributes(price_params)
        format.html { redirect_to admin_prices_path, :notice => 'Price was successfully updated.' }
        format.json { respond_with_bip @price }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip @price }
      end
    end
  end

  def destroy
    @price.destroy
    respond_to do |format|
      format.html { redirect_to admin_prices_path, notice: 'Age group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def price_params
      params.require(:price).permit!#(:name, :price)
    end

    def set_price
      @price = Price.find(params[:id])
    end
end
