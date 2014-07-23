class Address < ActiveRecord::Base
  
  belongs_to :addressable, :polymorphic => true

  geocoded_by :full_address

  # The following works and only fires if address is present and has changed since
  # last save, or has never been saved.  Do you need to code address_changed? to use
  # selective method?  There is none now.
  # http://stackoverflow.com/questions/12034179/using-after-validation-with-an-if-or-clause
  # after_validation :geocode, if: ->(address){ address.present? and address.address_changed? }
  after_validation :geocode

  def full_address
    [street, city, state, post_code].compact.join(', ')
  end

  # audited, not on Rails 4 yet
  
  def display_name
    'Address'
  end
  
  def to_s
    "#{street_address}, #{city}, #{state}, #{post_code}, #{map_reference}"
  end

end
