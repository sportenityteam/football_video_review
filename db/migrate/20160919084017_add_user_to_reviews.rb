class AddUserToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :user, index: true, foreign_key: true
    remove_column :reviews, :reviewer_id, :integer
  end
end
