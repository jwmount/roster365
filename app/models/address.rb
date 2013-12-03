class Address < ActiveRecord::Base
  
  belongs_to :addressable, :polymorphic => true

  # audited, not on Rails 4 yet
  
  def display_name
    'Address'
  end
  
  def to_s
    "#{street_address}, #{city}, #{state}, #{post_code}, #{map_reference}"
  end

end
