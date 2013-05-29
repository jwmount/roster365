class Requirement < ActiveRecord::Base
  attr_accessible :requireable_id, :requireable_type
  attr_accessible :certificate_id, :description
  
  audited

  belongs_to :certificate
  belongs_to :requireable, :polymorphic => true
  
  validates_presence_of :requireable_id, :requireable_type
  validates_presence_of :certificate_id

end
