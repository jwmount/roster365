class Reservation < ActiveRecord::Base

  belongs_to :schedule  
  #belongs_to :person
  belongs_to :equipment
  belongs_to :company

end