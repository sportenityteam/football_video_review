class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order, index: true, foreign_key: true
      t.integer :amount
      t.datetime :date_of_payment
      t.text :other_data
      t.string :status

      t.timestamps null: false
    end
  end
end
