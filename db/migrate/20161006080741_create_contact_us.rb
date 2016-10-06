class CreateContactUs < ActiveRecord::Migration
  def change
    create_table :contact_us do |t|
      t.string :subject
      t.string :email
      t.string :description

      t.timestamps null: false
    end
  end
end
