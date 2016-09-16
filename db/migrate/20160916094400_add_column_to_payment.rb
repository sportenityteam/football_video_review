class AddColumnToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :transcation_id, :string
  end
end
