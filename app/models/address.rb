class Address < ActiveRecord::Base
  attr_accessible :addressable_id, :addressable_type, :map_reference, :post_code, :state, :street_address, :city, :updated_at, :created_at
  
  belongs_to :addressable, :polymorphic => true

#  validates_presence_of  :addressable_type, :street_address, :city, :state
  audited
  
  def display_name
    'some name'
  end
  
  def entity_name
    "Who's address this is"
  end

  def to_s
    "#{street_address}, #{city}, #{state}, #{post_code}"
  end

end
