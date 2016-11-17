require "active_merchant/billing/rails"
class Payment < ActiveRecord::Base
  #associations
  belongs_to :order
  belongs_to :user

  # Validating the card automatically detects the card type
  def self.validate_credit_card(first_name,last_name,number,month,year,verification_value)
  	if first_name.present? and last_name.present?
	  	@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
	      :first_name         => first_name,
	      :last_name          => last_name,
	      :number             => number,
	      :month              => month,
	      :year               => year,
	      :verification_value => verification_value,
	    )
	  else
	  	@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
	      :first_name         => first_name,
	      :last_name          => first_name,
	      :number             => number,
	      :month              => month,
	      :year               => year,
	      :verification_value => verification_value,
	    )
	  end
	 	return @credit_card
	end

  #updated code

  def self.purchase_options(user,requested_ip)
    options = {
      ip: requested_ip,
      billing_address: {
        name:      user.fullname,
        address1:  "",
        city:      "",
        state:     "",
        country:   'US',
        zip:       user.zipcode
      }
    }
    puts "address:==#{options}=="
    options
  end

end
