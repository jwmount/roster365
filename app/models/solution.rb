#require "spreadsheet"
#require 'debugger'

class Solution < ActiveRecord::Base
  include Sluggable
  include ActiveModel::Validations
  
  # audited, not on Rails 4 yet
  
  # A S S O C I A T I O N S     A S S O C I A T I O N S     A S S O C I A T I O N S     A S S O C I A T I O N S     
  belongs_to :quote
  belongs_to :material
  belongs_to :vendor, 
             :class_name => 'Company', 
             :foreign_key => :vendor_id
  has_many :jobs, 
           :dependent => :destroy
  #has_many :equipment
  has_and_belongs_to_many :tips
  
  #
  # P O L Y M O R P H I C  A S S O C I A T I O N S
  #
  has_one :address,       
          :as => :addressable, 
          :autosave => true, 
          :dependent => :destroy
  has_many :requirements, 
           :as => :requireable, 
           :autosave => true, 
           :dependent => :destroy
  # NESTED -- Polys are managed from the parent           
    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :requirements

  scope :alphabetically, order("name ASC")
  
  #
  # V A L I D A T I O N S    V A L I D A T I O N S    V A L I D A T I O N S    V A L I D A T I O N S
  #
  validates_presence_of :name
<<<<<<< HEAD
  validates_presence_of :quote_id, :equipment_id, :tip_site
=======
  validates_presence_of :quote_id, :equipment_name
>>>>>>> equipment

  validates :invoice_load_client, :pay_load_client, :numericality => {:greater_than_or_equal_to => 0}
  validates :invoice_tip_client, :pay_tip_client, :numericality => {:greater_than_or_equal_to => 0}

  # validate :invoice_client_total
  validate :pay_amounts?
  validate :PO_required?


  # C O N T R A C T  T Y P E  V A L I D A T I O N S  --  I N C O M P L E T E
  # CONTRACT TYPE conditional validations -- given contract type, do we have what we need?
  #
  with_options :if => :export? do |s|
    s.validates :total_material, 
      :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than => 500001}
  end
  with_options :if => :import? do |s|
    s.validates :kms_one_way,
      :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than => 201}
  end

  # C O N S T A N T S  &  D E F A U L T S    C O N S T A N T S  &  D E F A U L T S    C O N S T A N T S  &  D E F A U L T S    
  UNITS_OF_MATERIAL = %w[m3 tonne loads]

  after_initialize :set_defaults
  #before_save :calculate_pay

  

  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?    
      self.solution_type ||= 'Export'
      self.client_approved ||= false
      self.drive_time_from_load_to_tip ||= 0
      self.drive_time_into_site ||= 0
      self.drive_time_into_tip ||= 0
      self.drive_time_out_of_site ||= 0 
      self.drive_time_tip_to_load ||= 0
      self.drive_time_out_of_tip_site ||= 0
      self.equipment_name ||= 'Unknown'
      self.invoice_load_client ||= 0.00
      self.pay_load_client ||= 0.00
      self.invoice_tip_client ||= 0.00
      self.pay_tip_client ||= 0.00
      self.kms_one_way ||= 0
      self.load_time ||= 0
      self.loads_per_day ||= 0
      self.pay_equipment_per_unit ||= 0.00
      self.pay_tip ||= 0.00
      self.pay_tolls ||= 0.00
      self.semis_permitted ||= false
      self.approved ||= false
      self.total_material ||= 0
      self.unit_of_material ||= 'm3'
      self.unload_time ||= 0
      self.purchase_order_required ||= self.quote.project.company.PO_required
      self.drive_time_out_of_tip_site ||= 0
      # Job delegates to :equipment_units_required_per_day
      
      self.invoice_load_client ||= 0.00
      self.pay_load_client ||= 0.00
      self.invoice_tip_client ||= 0.00
      self.pay_tip_client ||= 0.00
      self.hourly_hire_rate ||= 0.00
      
      self.equipment_units_required_per_day ||= 1
      self.equipment_dollars_per_day ||= 1250 unless self.equipment_dollars_per_day
    end
  end
  

  # Remember:  redirect_to include admin_project_*_path or breadcrumbs will be invalid.  
  def isApproved?
    #solution = Solution.find params[:id]
     # if solution
        if self.approved
           flash[:warning] = "Solution cannot be changed because it has final approval.  You can Copy it and edit that one."
           redirect_to admin_project_quote_solution_path(solution.quote.project.id,solution.quote.id, solution.id)
        end
      #end
  end

  def printed_quote
    s = 'Description of Works:  '
    case
    when self.blank?
      s += "____________ (type of agreement) of approximately ______________ (how much) of ______________ (kind of material) "
      s += "using _____________________________ (type of equipment).  "
    when self.solution_type == ('Hourly Hire' or 'hourly hire')
      s += "Hours worked @ $#{self.hourly_hire_rate}/hr.  "
    else # default case
      s += "#{self.solution_type} approximately #{self.total_material}"
      s += "#{unit_of_material} of "
      s += "#{material.name} with "
      s += "#{equipment.name}(s)."
      s += "Price: $#{invoice_load_client} per #{unit_of_material}.  "
    end
    s += "Plus GST."
  end

  # HACK. One that works quite well.  Simply enforces user work with singleton tip site.
  # Subject to error if we allow multiple sites checked, of course.
  # Should this association be :has_one instead of HABTM?
  def tip_site
    self.tips[0]
  end

  # A purchase order is required if the company requires one.
  # A purchase order may be required if T360 wants to have one.
  # No purchase order is acceptable if neither case is true.
  def PO_required?
    # company doesn't, true (acceptable) either way
    return true if !self.quote.project.company.PO_required
    # company requirement and true
    return true if self.quote.project.company.PO_required and self.purchase_order_required
    # company does and we didn't
    errors.add(:PO_required, "PROBLEM:  #{self.quote.project.company.name} requires a purchase order.")
  end
  
  def pay_amounts?
    
    # load & tip clients cannot be invoiced and paid
    if invoice_load_client > 0 and pay_load_client > 0
      errors.add(:invoice_load_client, "PROBLEM: Cannot invoice if load client is paid.")
      errors.add(:pay_load_client, "PROBLEM: Cannot pay if load client is invoiced.")
    end
    if invoice_tip_client > 0 and pay_tip_client > 0
      errors.add(:invoice_tip_client, "PROBLEM:  Cannot invoice if tip client is paid.")
      errors.add(:pay_tip_client, "PROBLEM:  Cannot pay if tip client is invoiced.")
    end
    
    errors.add(:pay_equipment_per_unit, "PROBLEM:  Pay equipment per unit amount must be entered.") if pay_equipment_per_unit.blank?
    errors.add(:pay_tolls, "PROBLEM:  Pay Tolls amount must be entered.") if pay_tolls.blank?
    #errors.add(:pay_tip, "PROBLEM:  Pay Tip Client amount must be entered.") if pay_tip.blank?
  end

  def generate_name
    self.name = "S#{quote.solutions.count+1}" if self.name.blank?
  end

  def display_name
    self.name
  end

  def m3?
    self.unit_of_material == "m3"
  end

  def tonne?
    self.unit_of_material == "tonne"
  end

  def loads?
    self.unit_of_material == "loads"
  end

  # Is this a blank to print a blank as a worksheet?
  # Note:  currently this requires solution_type is not required field.
  def blank?
    self.solution_type.blank? ? true : false
  end

  def import?
    self.solution_type == 'import'  or self.solution_type == 'Import'
  end

  def export?
    self.solution_type == 'export' or self.solution_type == 'Export'
  end
  
  def hourly_hire?
    self.solution_type == "hourly hire" or self.solution_type == 'Hourly Hire'
  end

  def has_final_approval?
    self.approved && client_approved
  end

end
