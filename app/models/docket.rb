class Docket < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :engagement
  
  validates_uniqueness_of :number
  validates_presence_of :number
  validates :engagement, presence => true

  # audited, not on Rails 4 yet

  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  after_initialize :set_defaults

  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?
      self.number ||= ""
      self.operator_signed ||= false
      self.client_signed ||= false
      self.approved ||= false
      self.approved_on ||= Date.today
      self.dated ||= Date.today
      self.received_on ||= Date.today
    end
  end
  
  def gross_amount
    a_inv_pay + b_inv_pay + supplier_inv_pay
  end

end
