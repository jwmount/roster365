class Docket < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :engagement
  
  validates_uniqueness_of :booking_no
  
  # audited, not on Rails 4 yet

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
