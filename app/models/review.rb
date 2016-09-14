class Review < ActiveRecord::Base
  #associations
  belongs_to :order
  has_many :reviewers, class_name: "User", foreign_key: "reviewer_id"

  #validations
  validates :technical_notes , :presence => true
  validates :tactical_notes , :presence => true
end
