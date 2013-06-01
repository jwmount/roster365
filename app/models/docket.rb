class Docket < ActiveRecord::Base
  attr_accessible :booking_no, :date_worked, :dated, :received_on, :operator_signed, :client_signed
  attr_accessible :T360_approved, :T360_approved_by, :T360_approved_on, :T360_2nd_approval, :T360_2nd_approval_by
  attr_accessible :T360_2nd_approval_on, :T360_2nd_approval_on, :a_inv_pay, :b_inv_pay, :supplier_inv_pay
  attr_accessible :engagement_id, :person_id
  
  belongs_to :contact
  belongs_to :engagement
  
#  validates_presence_of :booking_no
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
      self.T360_approved ||= false
      self.T360_2nd_approval ||= false
    end
  end
  
end
