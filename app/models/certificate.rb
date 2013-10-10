class Certificate < ActiveRecord::Base


  # audited, not on Rails 4 yet
  
  has_many :certs, dependent: :destroy

  scope :alphabetically, order("name ASC")
    
  validates :name,          :presence => true

  def display_name
    self.name
  end
  
end
