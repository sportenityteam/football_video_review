class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status, default:1
      t.integer :total_video_duration

      t.timestamps null: false
    end
  end
end
