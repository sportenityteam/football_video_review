class Order < ActiveRecord::Base
  #Search
  include PgSearch
  pg_search_scope :search_items, :against => [:id, :created_at]

  #Enum
  #STATUS = { "New" => 1 , "Admin Approved/Waiting for review" => 2, "Admin rejected" => 3, "Reviewed" => 4, "Review approved" => 5, "Review rejected" => 6, "In review" => 7 }
  STATUS = { "Pending" => 1 , "Admin Approved" => 2, "Admin rejected" => 3, "Reviewed" => 4, "Review approved" => 5, "Review rejected" => 6, "In review" => 7 }

  after_create :send_admin_reviewer_mail

  #associations
  belongs_to :user
  has_many :videos, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :payment, dependent: :destroy

  #validations
  validates :title, :presence => true

  #Nested attributes
  accepts_nested_attributes_for :videos, allow_destroy: true

  #send mail to reviewer and admin for new video create
  def send_admin_reviewer_mail
    @order = self
    puts "=-=-=-=-=-=-=-=-=-=--=-= #{@order.inspect}"
    @users = User.not_user
    @users.each do |user|
      OrderMailer.send_new_order_message(@order,user).deliver_now
    end
  end

end
