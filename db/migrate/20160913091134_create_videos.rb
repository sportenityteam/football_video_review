class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :order, index: true, foreign_key: true
      t.integer :duration
      t.text :description

      t.timestamps null: false
    end
  end
end
