class Address < ActiveRecord::Base
  
  belongs_to :addressable, :polymorphic => true

#  validates_presence_of  :addressable_type, :street_address, :city, :state
  # audited, not on Rails 4 yet
  
  def display_name
    'Address'
  end
  
  def to_s
    "#{street_address}, #{city}, #{state}, #{post_code}, #{map_reference}"
  end

end
