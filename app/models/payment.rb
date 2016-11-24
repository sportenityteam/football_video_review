require "active_merchant/billing/rails"
class Payment < ActiveRecord::Base
  #associations
  belongs_to :order
  belongs_to :user

  #before_create :validate_card

  def purchase(amount, card_number, month, year, cvv, first_name, last_name, requested_ip, user)
    response = GATEWAY.purchase(amount,credit_card(first_name,last_name,card_number,month,year,cvv), purchase_options(requested_ip,user))
    logger.warn("============response==========#{response.inspect}")
    return response
  end

  private

  def purchase_options(requested_ip,user)
    logger.warn("==========user========#{user.inspect}")
    values = {
            ip: requested_ip,
            billing_address: {
                name:      user.fullname,
                address1:  "",
                city:      "",
                state:     "",
                country:   "US",
                zip:       user.zipcode
            }
        }
    logger.warn("============values==========#{values.inspect}")
    return values
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
      end
    end
  end

  # Validating the card automatically detects the card type
  def credit_card(first_name,last_name,number,month,year,verification_value)
    if first_name.present? and last_name.present?
      @credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => first_name,
        :last_name          => last_name,
        :number             => number,
        :month              => month,
        :year               => year,
        :verification_value => verification_value,
      )
    else
      @credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => first_name,
        :last_name          => first_name,
        :number             => number,
        :month              => month,
        :year               => year,
        :verification_value => verification_value,
      )
    end
    logger.warn("============credit_card==========#{@credit_card.inspect}")
    return @credit_card
  end

end
