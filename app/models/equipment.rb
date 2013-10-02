#require 'debugger'; debugger

class Equipment < ActiveRecord::Base

  
  # audited, not on Rails 4 yet

  belongs_to :company
  has_many :solutions, :dependent => :destroy

  # polymorphs
  has_many :certificates, :through => :certs
  has_many :certs, :as => :certifiable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :certs

  validates :name, :presence => true

  scope :alphabetically, order("name ASC")

  def certificate_list
    certificates = self.certs  #[0].certificate.name
    list = certificates.collect! {|x| x.certificate.name + "; " }
    list.join()
  end
  
  def company_list
    companies = companies_equipment.all
    list = ompanies.collect! {|x| x.company.name + "; " }
    list.join()
  end
    
  def display_name
    self.name
  end
  

end
