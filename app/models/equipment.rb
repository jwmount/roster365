#require 'debugger'

class Equipment < ActiveRecord::Base

  # audited, not on Rails 4 yet

  belongs_to :company
  belongs_to :solution
  has_many :solutions, :dependent => :destroy
#  has_and_belongs_to_many :schedules

  #
  # P O L Y M O R P H I C  A S S O C I A T I O N S
  #
  #has_many :certificates, :through => :certs
  has_many :certs, 
           :as => :certifiable, 
           :autosave => true, 
           :dependent => :destroy
  # NESTING
  accepts_nested_attributes_for :certs

#
# V A L I D A T I O N S
#
  validates :name, :presence => true

  scope :alphabetically, order("name ASC")

# D E F A U L T S

  after_initialize :defaults

  def defaults
     unless persisted?
       # list default values here
    end
  end

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
  
# List of defined equipment.  Used to protect consistent names.
def equipment_list
  [
    "Backhoe",
    "Bobcat",
    "Compactor",
    "Compactor 815",
    "Compactor 815F",
    "Compactor 825G",
    "Compactor 825H",
    "Crane",
    "Dozer-D3",
    "Dozer-D6",
    "Dozer D6M Swamp",
    "Dozer D6R Swamp",
    "Dozer D6T XL",
    "Dozer-D6H",
    "Dozer-D65",
    "Dozer - D6C",
    "Dozer - D6R",
    "Dozer - D6R Xl",
    "Dozer - D7",
    "Dozer - D7H",
    "Dozer - D8",
    "Dozer - D9T",
    "Dozer R -D9",
    "Dump Truck 25T",
    "Dump Truck 30T",
    "Dump Truck 40T",
    "Dump Truck 50T",
    "Drott 9T",
    "Drott 8T",
    "Drott",
    "Excavator",
    "EXC 8T",
    "EXC 12-22T ",
    "EXC 12T",
    "EXC 13T",
    "EXC13.5T",
    "EXC 14T",
    "EXC 15T",
    "EXC 17T WHEELED",
    "EXC 18T",
    "EXC 20-29T",
    "EXC 20T WHEELED",
    "EXC 20T",
    "EXC 20T ",
    "EXC 20T 8T 12",
    "EXC 22T",
    "EXC 24T",
    "EXC 25T",
    "EXC 30T",
    "EXC 35T",
    "EXC 40T",
    "EXC 45T",
    "EXC 60T",
    "EXC 4.5T ",
    "EXC 4T",
    "EXC 3.5T",
    "EXC 3T COMBO",
    "EXC 3T",
    "EXC 5T",
    "EXC 5T COMBO",
    "EXC 5T ",
    "EXC 5.5T",
    "EXC 5-10T",
    "EXC 5-30T",
    "EXC 5T & 6T",
    "EXC 6T",
    "EXC 6T ",
    "EXC 7.5T",
    "EXC 7.5T ",
    "EXC 8T ",
    "Float",
    "Grader 12G 140H",
    "Grader",
    "IT Loader",
    "Loader",
    "Moxy Dump",
    "Moxy Dump 20T",
    "Moxy Dump 25T",
    "Moxy Dump 30T",
    "Posi Track",
    "Pug Mill",
    "Roller Pad SF",
    "Roller Smooth",
    "Roller 12T",
    "Roller",
    "Roller 14T",
    "Roller Smooth 12T",
    "Roller Pad SF 12T",
    "Roller Pad",
    "Roller Pad SF 16T",
    "Scraper 633",
    "Scraper 623E",
    "Scraper",
    "Screening Plant",
    "Semi",
    "Semi/T & T",
    "Semi Tipper",
    "Sweeper",
    "Tilt Tray",
    "Truck",
    "Truck & 3 Axle Trailer",
    "Truck & 4 Axle Trailer",
    "Truck & Dog",
    "Watercart"
    ]
  end

end
