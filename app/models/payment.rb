class Payment < ActiveRecord::Base
  #associations
  belongs_to :order

  # Validating the card automatically detects the card type
  def self.validate_credit_card(first_name,last_name,number,month,year,verification_value,brand)
  	if first_name.present? and last_name.present?
	  	@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
	      :first_name         => first_name,
	      :last_name          => last_name,
	      :number             => number,
	      :month              => month,
	      :year               => year,
	      :verification_value => verification_value,
	      :brand               => brand
	    )
	  else
	  	@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
	      :first_name         => first_name,
	      :last_name          => first_name,
	      :number             => number,
	      :month              => month,
	      :year               => year,
	      :verification_value => verification_value,
	      :brand              => brand
	    )
	  end
	 	return @credit_card
	end

end
