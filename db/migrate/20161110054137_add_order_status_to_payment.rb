class AddOrderStatusToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :order_status, :string
  end
end
