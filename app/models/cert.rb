#  Certificate -- the document itself.  We use the name and describe it's characteristics.
#  Cert -- the state of having some Certificate (or qualification or property)
#  Certs are polymorphic with certifiable_types expected to be:
#   - Company, e.g. ISO 9000, Australian Owned
#   - Person, e.g. QLD Driving License, Australian Citizen, Pink Card
#   - Equipment, e.g. Insured, Mud flaps, Aluminum Body...etc.
#   - Site, e.g. ABC tip is Fire Ant free.
#  Requirements
#   Solutions may require Certs, e.g. 'must have automatic tarpolin covers'
#   Companies may require Certs, e.g. 'must be military veteran'

class Cert < ActiveRecord::Base
  
  belongs_to :certificate
  belongs_to :certifiable, :polymorphic => true
  
  # audited, not on Rails 4 yet
  
  def defaults
    unless persisted?
      self.active ||= true
      self.permanent ||= false
      self.expires_on ||= Date.today
      self.serial_number ||= '000000'
    end
  end

end
