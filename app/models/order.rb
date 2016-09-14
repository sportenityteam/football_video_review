class Order < ActiveRecord::Base
  #Enum
  STATUS = { "New" => 1 , "Admin Approved/Waiting for review" => 2, "Admin rejected" => 3, 
	"Reviewed" => 4, "Review approved" => 5, "Review rejected" => 6 }

  #associations
  belongs_to :user
  has_many :videos
  has_many :reviews
  has_one :payment

  #validations
  validates :title, :presence => true
end
