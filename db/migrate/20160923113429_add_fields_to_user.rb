class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :soccer_club, :string
    add_column :users, :soccer_goal, :string
  end
end
