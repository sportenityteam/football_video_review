class Order < ActiveRecord::Base
  #Enum
  STATUS = { "New" => 1 , "Admin Approved/Waiting for review" => 2, "Admin rejected" => 3, "Reviewed" => 4, "Review approved" => 5, "Review rejected" => 6 }

  #associations
  belongs_to :user
  has_many :videos, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :payment, dependent: :destroy

  #validations
  validates :title, :presence => true

  #Nested attributes
  accepts_nested_attributes_for :videos, allow_destroy: true

end
