class Requirement < ActiveRecord::Base
  
  # audited, not on Rails 4 yet

  belongs_to :certificate
  belongs_to :requireable, :polymorphic => true
  
  validates_presence_of :requireable_id, :requireable_type
  validates_presence_of :certificate_id

end
