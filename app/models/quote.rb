require 'active_support/core_ext/date/calculations.rb'
require 'active_support/core_ext/date_time/calculations.rb'
require 'active_support/core_ext/time/calculations.rb'
require 'active_support/core_ext/object/blank.rb'
#require 'debugger'

class Quote < ActiveRecord::Base
  include Sluggable

  attr_accessible :name, :rep_id, :quote_to_id, :project_id
  attr_accessible :council, :duration, :expected_start, :fire_ants, :fire_ants_verified_by, :inclusions
  attr_accessible :addresses_attributes

  
  belongs_to :project
  
  has_many :solutions, :dependent => :destroy
  has_many :jobs, :through => :solutions

  has_many :requirements
  has_many :certificates, :through => :requirements
  has_one  :rep,          :as => :person

  # polymorphs
  

  # Do not :scope => :project, this will cause arel to ROLLBACK with 'Cannot visit Project'
  # :name does not have to be unique to allow deep copy of quote with its solutions.
  # Doing this means new_quote will have solutions S01 and S02 if basis of copy had them.
  # validates_uniqueness_of :name #, :scope => :project
  validates_presence_of :project_id, :quote_to_id, :duration
  validates_presence_of :fire_ants_verified_by #, :inclusions

  audited
  after_initialize :set_defaults
  serialize :inclusions

#  scope :quote_to_id, where("company_id = ?", 1)


  QUOTE_UPDATE_OK = "Quote updated."
  
  def load_site_address
    begin
      @address = Address.where("addressable_id = ? AND addressable_type = ?", self.id, 'Quote').limit(1)
      address = "#{@address[0].street_address},  #{@address[0].city} #{@address[0].state} #{@address[0].post_code} "
    rescue ActiveRecord::RecordNotFound
      address = "No address given."
    end
    address
  end

  def conditions
    Condition.where(:indication => solutions.all.collect{ |s|  [s.solution_type, 'Required'] })
  end

  def set_defaults
    generate_name
    unless persisted?
      self.expected_start ||= Time.zone.now + 1.day
      self.duration ||= 1
      self.include_required_conditions
      self.fire_ants ||= true
      # self.fire_ants_verified_by set by :after_build in quotes.rb
    end
  end

  def generate_name
    self.name = "Q#{Quote.count+1+5000}" unless self.name
  end

  def quote_to_name
    contact = Person.find self.quote_to_id
    contact.display_name
  end
  
  def prep_name
    m = ""
    begin
      prep = Person.find (self.project.rep_id)
      m << prep.full_name
    rescue ActiveRecord::RecordNotFound
      m << "Not assigned."
    end
    m
  end

  def qrep_name
    m = ""
    begin
      prep = Person.find (self.rep_id)
      m << prep.full_name
    rescue ActiveRecord::RecordNotFound
      m << "Not assigned." 
    end
    m
  end

  # Benefits though:  printed quotes simply use @quote.conditions.  A permanent history is created (based on @quote.inclusions).
  #solution_types = []
  #@solutions.each do |s|
  #  logger.info("*_*_*_*_*_ Solution requires condition: #{s.solution_type}")
  #  solution_types << s.solution_type
  #end
  #@conditions = Condition.where( :indication => solution_types )
  

  def include_required_conditions
    #inclusions = []
    conditions = Condition.where("indication = ?", 'Required')
    self.inclusions = conditions.inject([]) { |c,i| c << i }
      
    #conditions.each do |condition|      
    #  if condition.indication.downcase.include?("required")
    #    inclusions << condition 
    #  end
    #end

    # Fire Ants Present is Yes or No, use one Condition
    # Both are required, remove one based on value of Quote::fire_ants
    #if self.fire_ants        
    #  condition =  inclusions.delete_if {|c| c.verbiage.downcase.include?("Fire Ants Not Present") }  
    #else
    #  inclusions.delete_if {|c| c.name.downcase.include?("Fire Ants Present") }        
    #end
    
    #self.inclusions = inclusions    
    #puts "*** *** ***  #{self.inclusions.inspect}"
  end

  # Save the conditions with the quote itself.
  # At this time this mechanism simply adds the included conditions ('the conditions') to the @quote.
  # These accumulate, none are ever removed or replaced.  This may be unweildy and can be refined as necessary.
  # However the Condition object is serialized so it should be easy to replace them if they're already in conditions[].
  # Deprecated.
  def Xinclude_condition(params)
    @condition = Condition.find params[:condition_id]
    inclusions = []
    inclusions << @condition
    inclusions << self.inclusions
    self.inclusions = inclusions

    if self.save!
      logger.info("*-*-*-*-* Ops Event: #{@condition.name} -- included in quote #{self.id.to_s}.")
    end
  end


end

