class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :order, index: true, foreign_key: true
      t.integer :reviewer_id
      t.text :technical_notes
      t.text :tactical_notes
      t.integer :review_time

      t.timestamps null: false
    end
  end
end
