class AddOtherFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
    add_column :users, :current_club, :string
    add_column :users, :description, :text
  end
end
