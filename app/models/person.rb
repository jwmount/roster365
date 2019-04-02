class Person < ActiveRecord::Base

  # audited, not on Rails 4 yet

  # acts_as_authentic do |c|
  #   c.logged_in_timeout = 20.minutes # default is 10.minutes
  # end # the configuration block is optional

  belongs_to :company
  
  has_many :dockets, :dependent => :destroy
  has_many :engagements, :dependent => :destroy
  #has_many :reservations, :dependent => :destroy
  has_and_belongs_to_many :schedules
  
  #
  # P O L Y M O R P H I C  A S S O C I A T I O N S
  #
  has_many  :addresses, 
            :as           => :addressable, 
            :autosave     => true, 
            :dependent    => :destroy

  has_many :certs, 
           :as            => :certifiable, 
           :autosave      => true, 
           :dependent     => :destroy

  has_many :identifiers, 
           :as            => :identifiable, 
           :autosave      => true, 
           :dependent     => :destroy

  # NESTING           
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :certs
  accepts_nested_attributes_for :identifiers
  
  # Update scopes for rails 5.2.2
  # scope :alphabetically, -> { order: ("last_name DESC") }
  # scope :post_code,      -> { where(certifiable_type: "Person")}
  
  delegate :post_code, :to => :address

#
# V A L I D A T I O N S
#
  validates_presence_of :last_name

#
# D E F A U L T S
#
  after_initialize :defaults
  def defaults
     unless persisted?
       self.active           ||= true
       self.OK_to_contact    ||= true
       self.available        ||= true
       self.OK_to_contact    ||= true
       self.available_on     ||= Date.today + 1.day
    end
  end


  def display_name
    full_name
  end

  def full_name
    [self.first_name, self.last_name].compact.join ' '
  end
    
  def address
    @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Company').limit(1)
    unless @address.blank?
      address = "#{@address[0].street_address},  #{@address[0].city} #{@address[0].state} #{@address[0].post_code} "
    else
      'Empty'
    end
  end
    
end

