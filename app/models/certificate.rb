class Certificate < ActiveRecord::Base


  # audited, not on Rails 4 yet
  
  has_many :certs
  has_many :requirements

  scope :alphabetically, order("name ASC")
    
  validates :name,          :presence => true

  def display_name
    self.name
  end
  
end
