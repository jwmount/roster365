class Certificate < ActiveRecord::Base
  attr_accessible :active, :description, :for_company, :for_person, :for_equipment, :name

  audited
  
  has_many :certs
  has_many :requirements

  scope :alphabetically, order("name ASC")
    
  validates :name,          :presence => true

  def display_name
    self.name
  end
  
end
