class Review < ActiveRecord::Base
  #associations
  belongs_to :order
  belongs_to :user

  #validations
  validates :technical_notes , :presence => true
  validates :tactical_notes , :presence => true
end
