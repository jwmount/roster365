class Docket < ActiveRecord::Base
  attr_accessible :booking_no, :date_worked, :dated, :received_on, :operator_signed, :client_signed
  attr_accessible :approved, :approved_by, :approved_on
  attr_accessible :a_inv_pay, :b_inv_pay, :supplier_inv_pay
  attr_accessible :engagement_id, :person_id
  
  belongs_to :person
  belongs_to :engagement
  
  validates_uniqueness_of :booking_no
  
  audited

  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  after_initialize :set_defaults

  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?
      self.booking_no ||= nil
      self.operator_signed ||= false
      self.client_signed ||= false
      self.approved ||= false
    end
  end
  
end
