class Contact < ActiveRecord::Base

# A T T R I B U T E S   &  D E F A U L T S
  attr_accessible :OK_to_contact, :available, :company_id, :first_name, :last_name, :next_available_on, :title, :active
  attr_accessible :addresses_attributes, :identifiers_attributes, :certs_attributes
  attr_accessible :cert_ids
  after_initialize :defaults

  # self.assoc = [OtherModel.find_by_name('special')]
  # self.address ||= build_address #let's you set a default association
  def defaults
     unless persisted?
       self.OK_to_contact    ||=true
       self.available        ||=true
       self.next_available_on||=Date.today
    end
  end

  audited

  # acts_as_authentic do |c|
  #   c.logged_in_timeout = 20.minutes # default is 10.minutes
  # end # the configuration block is optional

  belongs_to :company
  has_many :dockets
  has_many :engagements
  
  # polymorphs
  has_many  :addresses,     :as => :addressable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :addresses

  has_many :certificates, :through => :certs
  has_many :certs, :as => :certifiable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :certs

  has_many :identifiers, :as => :identifiable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :identifiers
  
  has_and_belongs_to_many :schedules

  scope :alphabetically, order("last_name DESC")
  scope :personally, where("certifiable_type = 'Contact'")
  
  delegate :post_code, :to => :address


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

