class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  #Search
  include PgSearch
  pg_search_scope :search_items, :against => [:first_name, :last_name, :current_club, :soccer_club]

  #Enum
  USER_TYPES =  { "admin" => 1, "reviewer" => 2, "user" => 3}

  # User GENDER = {"male" => 1, "female" => 2}

  #callback
  before_validation :check_for_password

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
  validates_numericality_of :zipcode, :greater_than_or_equal_to => 0 , message: " must have only digits from 0 to 9"
  validates_length_of :zipcode , :minimum => 5 , :message => "must be 5 characters long"

  #scope
  scope :is_admin, -> {where("user_type =? ", 1)}
  scope :is_reviewer, -> {where("user_type =? ", 2)}
  scope :is_user, -> {where("user_type =? ", 3)}
  scope :not_user, -> {where("user_type !=? ", 3)}


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

  #calculating registered user's age
  def self.calculate_amount_from_age(dob)
    dob = DateTime.strptime(dob, '%m/%d/%Y')
    now = Time.zone.now.to_date
    age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    amount = Price.calculate_amount(age)
    return amount
  end

  def check_for_password
    if self.password.nil?
      self.password = "12345678"
    end
  end

end
