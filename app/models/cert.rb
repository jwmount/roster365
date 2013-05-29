#  Certificate -- the document itself.  We use the name and describe it's characteristics.
#  Cert -- the state of having some Certificate.
#  Certs are polymorphic with certifiable_types expected to be:
#   - Company, e.g. ISO 9000, Australian Owned
#   - Contact, e.g. QLD Driving License, Australian Citizen, Pink Card
#   - Equipment, e.g. Insured, Mud flaps, Aluminum Body...etc.
#  Requirements
#   Solutions may require Certs, e.g. 'must have automatic tarpolin covers'
#   Companies may require Certs, e.g. 'must be military veteran'

class Cert < ActiveRecord::Base
  attr_accessible :certifiable_id, :certifiable_type
  attr_accessible :active, :certificate_id, :expires_on, :permanent, :serial_number
  
  belongs_to :certificate
  belongs_to :certifiable, :polymorphic => true
  
  audited
  
end
