# require 'debugger'; debugger
class Company < ActiveRecord::Base
  ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)
  #audited  not on Rails 4 yet?

  has_many :people, :dependent => :destroy
  has_many :equipment, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :reservations
  # We do not use :dependent => :destroy as tips survive company owners.  OK?
  has_many :tips

  # polymorphs
  has_many  :addresses, 
            :as => :addressable, 
            :autosave => true, 
            :dependent => :destroy

  has_many :certs, 
           :as => :certifiable, 
           :autosave => true, 
           :dependent => :destroy

  has_many :identifiers, 
           :as => :identifiable, 
           :autosave => true, 
           :dependent => :destroy

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :certs
  accepts_nested_attributes_for :identifiers


#
# V A L I D A T I O N S
#
  validates_presence_of :name
  validates_uniqueness_of :name

  # conditional validations -- bookeeping_number
  # note that :if clause is a hash and NOT a comparison
  # bookeeping_number number must be unique 5 digits if given, otherwise may be blank.
  with_options :if => :is_bookeeping_number? do |c|
     c.validates_presence_of :bookeeping_number, 
     :numericality => { :only_integer => true, 
                        :greater_than_or_equal_to => AdminConstants::ADMIN_COMPANY_BOOKEEPING_NO_BASE,
                        :less_than_or_equal_to => AdminConstants::ADMIN_COMPANY_BOOKEEPING_NO_MAX,
                        :equal_to => AdminConstants::ADMIN_COMPANY_BOOKEEPING_NO_DEFAULT
                      }
  end

#
# D E F A U L T S
#
  after_initialize :defaults

  def defaults
     unless persisted?
    end
  end
  
  def is_bookeeping_number?
    !self.bookeeping_number.blank?
  end
  
  def display_name
    name
  end

  def show_people(company)
    'contact'
  end

  def address
    @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Company').limit(1)
    unless @address.blank?
      address = "#{@address[0].street_address},  #{@address[0].city} #{@address[0].state} #{@address[0].post_code} "
    else
      'Empty'
    end
  end

  def map_reference
    @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Company').limit(1)
    unless @address.nil?
      map_reference = "#{@address[0].map_reference}"
    else
      map_reference = 'Empty'
    end
  end  
    
  def equipment_list
    list = ""
    self.equipment.each do |e|
      list << "#{e.name}, "
    end
    return nil if list.all.empty?  
    list.rstrip.chop!
  end
  
  def rollodex
    list = ""
    self.identifiers.order(:rank).each do |i|
      list << "#{i.name}: #{i.value}  "
    end      
    list
  end


end
