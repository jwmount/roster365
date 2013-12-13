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
  after_initialize :has_equipment_required?

  # Best practice in Rails is set defaults here and not in database
  # docket_id may default to nil since at engagement time no docket(s) will exist normally.
  # At this time, all default values are set in the DB.  See schema.rb.
  def set_defaults
    unless persisted?
    end
  end

  #
  # V A L I D A T I O N S
  #
  validates_presence_of :schedule_id
  validates_presence_of :person_id

  # Validation:  Does the company of the driver selected actually have the equipment required?
  def has_equipment_required?
    # Do we know what the required equipment is?
    begin
      equipment_name = self.schedule.job.solution.equipment_name
    rescue Exception
      # apparently not, normally due to loss of schedule as context since then cannot determine what equipment the 
      # solution stipulates.
      errors.add(:person, "PROBLEM: Person selected is with a company that does not have equipment required.")
      return false
    end    
    return true
    #does the subbie work for a company that has what's required for the solution?
    # want the equipment list of person.company.equipment to contain :equipment
    equipment_list = self.person.company.equipment.where("name = ?", equipment_name)
    if equipment_list.all.empty?
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

  # scope of this is supposed to be drivers from companies that have right equipment.
  # 'Right' equipment means units of right kind with all or most?  required certificates.
  # So far we just get people from all companies with equipment we need.
  def people_with_equipment_required
    #Person.alphabetically.all.map {|u| [u.display_name, u.id]}
    equipment = Equipment.where(
      "name = :name",
      { name: self.schedule.job.solution.equipment_name }
      )
    # now get companies that have the equipment
    company_list = []
    equipment.each do |e|
      company_list << e.company.id
      end
    companies = Company.find company_list
    qualified_people = []
    companies.each do |c|
      qualified_people << c.people
    end
    #list = equipment.collect! {|x| x.name}
    names = qualified_people.flatten.collect!
    names
  end
    
  # Person.alphabetically.all.map {|u| [u.display_name, u.id]}
  # people_with_required_certs_and_whose_companies_have_equipment, or
  # people who work for companies with equipment_name who have certificates required.
  def people_who_meet_requirements
    # first get companies who have equipment required
    equipment = Equipment.where(
      "name = :name",
      { name: self.schedule.job.solution.equipment_name }
      )
    #list = Person.where(
    #   "for_people = :for_company OR for_equipment = :for_equipment OR for_person = :for_person",
    #   { for_company: true, for_equipment: true, for_person: true }
    #)
  end

end

