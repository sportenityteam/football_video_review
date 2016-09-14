class Price < ActiveRecord::Base
	#validations
	validates :name, :presence => true
	validates :price, :presence => true
end
