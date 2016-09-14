class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :gender, :integer
    add_column :users, :position, :string
    add_column :users, :zipcode, :string
    add_column :users, :user_type, :integer
  end
end
