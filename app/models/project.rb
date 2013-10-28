#require 'debugger'

class Project < ActiveRecord::Base
  #include Sluggable

  # audited, not on Rails 4 yet

  belongs_to :company

  has_many :certificates, :through => :requirements
  has_many :quotes,       :dependent => :destroy
#  has_one  :rep,          :as => :person
#  has_one  :rep
  has_many  :people

#
# P O L Y M O R P H I C  A S S O C I A T I O N S
#
  has_many  :addresses,     
            :as => :addressable, 
            :autosave => true, 
            :dependent => :destroy

  has_many :requirements,
           :as => :requireable,
           :autosave => true,
           :dependent => :destroy

# polymorpth classes are updated directly from the parent            
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :requirements


  #
  # V A L I D A T I O N S
  #
  validates_presence_of :name
  validates_presence_of :company_id

  #
  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  #
  after_initialize :set_defaults
  
  # Best practice in Rails is set defaults here and not in database; however
  # Xavier Shay disagrees, going with his approach.  Thus set defaults in schema.
  def set_defaults
    unless persisted?
      self.project_start_on  ||= Time.now
    end
  end

  def address
    #@address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Project').limit(1)
    if self.address.empty?
      'No address'
    else
      self.street_address
    end
  end

  # form of find works, see use to scope to employee Reps in projects.rb
  def XXrequirement_list
    Certificate.where({:for_company => true} | {:for_person => true}) - certificates
  end


end

