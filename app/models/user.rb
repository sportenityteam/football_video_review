class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #before_action :authenticate_user!

  #Enum
  USER_TYPES =  { "admin" => 1, "reviewer" => 2, "user" => 3}

  # User GENDER = {"male" => 1, "female" => 2}

  #associations
  has_many :orders

  #paperclip
  has_attached_file :avatar,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename",
                    :default_url => "missing_user.png",
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  #validations
  validates_attachment_content_type :avatar, content_type: ['image/png', 'image/jpg','image/gif','image/jpeg']
  validates :first_name, :presence => true
  validates :date_of_birth, :presence => true

  #instance methods
  def fullname
    if first_name.present? and last_name.present?
      "#{first_name.capitalize} #{last_name.capitalize}"
    else
      "#{first_name.capitalize}"
    end
  end

  #Methods to check user types
  def is_user?
    self.user_type == 3
  end

  def is_reviewer?
    self.user_type == 2
  end

  def is_admin?
    self.user_type == 1
  end
end
