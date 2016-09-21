class Admin::PricesController < Admin::BaseController

  #respond_to :html, :json

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
  end

  def edit
  end

  def update
    # @price = Price.find(params[:id])
    # @price.update_attributes(price_params)
    # respond_with @price

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

  private

    def price_params
      params.require(:price).permit!#(:name, :price)
    end
end
