class Price < ActiveRecord::Base
	#validations
	validates :name, :presence => true
	validates :price, :presence => true

	#calculating amount for placing order
	def self.calculate_amount(age)
		if age <= 12
			amount = Price.find_by_name("12 and under").price
		else
			amount = Price.find_by_name("13 and up").price
		end
		return amount*100
	end
end
