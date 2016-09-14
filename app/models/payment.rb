class Payment < ActiveRecord::Base
  #associations
  belongs_to :order
end
