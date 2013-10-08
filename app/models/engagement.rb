#require 'debugger'
class Engagement < ActiveRecord::Base
      
  belongs_to :person
  belongs_to :schedule
  has_many   :dockets
  
  # audited, not on Rails 4 yet

  # Scope syntax introduced in Rails 4.0.0
  # scope is 'within some date'
  # scope :published, -> { where('published_on <= ?', Time.now.to_date) }

  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  after_initialize :set_defaults

  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?
      self.OK_tomorrow ||= false
      self.breakdown ||= false
      self.date_next_available ||= Date.today + 1
      self.next_available_day ||= Date.today + 1
      self.no_show ||= false
      self.onsite_at ||= false
      self.onsite_now ||= false
    end
  end

  #
  # V A L I D A T I O N S
  #
  # validates_uniqueness_of :booking_no #, :scope => :project
  validates_presence_of :schedule_id
  validate :has_equipment_required?
  
  # Validation:  Does the company of the driver selected actually have the equipment required?
  def has_equipment_required?
    # Do we know what the required equipment is?
    begin
      equipment_name = self.schedule.job.solution.equipment.name
    rescue Exception
      # apparently not, normally due to loss of schedule as context since then cannot determine what equipment the 
      # solution stipulates.
      errors.add(:person, "PROBLEM: Person selected is with a company that does not have equipment required.")
      return false
    end    
    
    #does the subbie work for a company that has what's required for the solution?
    # want the equipment list of person.company.equipment to contain :equipment
    equipment_list = self.person.company.equipment.where("name = ?", equipment_name)
    if equipment_list.count == 0
      errors.add(:person, "WARNING:  The person selected is from a company that does not have the equipment required.  " +
        "Suggestion:  Use Equipment list and filter with name = #{equipment_name}." +
        "It is also possible the Equipment inventory of the company involved needs to be updated.")
    end
  end

  def display_name
    self.schedule.job.name + 'initials'
  end

  def start_time
    self.schedule.day.strftime("%H:%M")
  end

  def equipment
    self.schedule.job.solution.equipment.name    
  end
    

end

