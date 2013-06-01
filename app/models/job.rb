#require 'debugger'

class Job < ActiveRecord::Base
  attr_accessible :active, :complete, :name, :solution_id, :start_on, :time, :finished_on
  attr_accessible :purchase_order
  attr_accessible :solution_ids
  
  belongs_to :solution

  has_one :company
  has_many :dockets
  has_many :schedules

  audited

  validates :name, :presence => true
  validate :is_solution_approved?
  validate :purchase_order_required?

  delegate :equipment_units_required_per_day, :to => :solution, :allow_nil => true

  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  after_initialize :set_defaults
  
  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?    
      self.active ||= false
      self.complete ||= false
      self.start_on ||= Date.today
      self.finished_on ||= Date.today + 1
    end
  end
  
  scope :is_active?, where(:active => true)
  scope :is_not_active?, where(:active => false)
  scope :starting_from_today, where("DATE(start_on) >= DATE(NOW())")

# pg errors on next two scopes on heroku
#  scope :started, where("DATE(start_on) <= DATE(NOW() + INTERVAL 3 DAY)")
#  scope :ongoing, where("DATE(finished_on) >= DATE(NOW() + INTERVAL 1 DAY)")
  scope :by_start_on, order("start_on DESC")


  JOB_UPDATE_OK = "Job was updated."


  # See if a solution requires a PO in order to create a job...
  def purchase_order_required?
    if self.solution.purchase_order_required && self.purchase_order.blank?
      errors.add(:purchase_order_required, "PROBLEM:  A purchase order is required for solution #{self.solution.name}.")
    end
  end
  
  def equipment_units_required_per_day
    solution.equipment_units_required_per_day
  end

  class << self
    def approved
      includes(:solution).where("solutions.approved = ? && solutions.client_approved = ?", true, true)
    end
  end

  def is_solution_approved?
    solution && solution.approved?
  end

  def complete?
    solution && solution.complete?
  end

  # get Project Rep 
  def prep
    begin
      @prep = Person.find (self.solution.quote.project.rep_id)
    rescue ActiveRecord::RecordNotFound
      @prep = Person.new(:last_name=>'none')
    end
  end

  # get Quote Rep full name (may be same as prep)
  def qrep
    begin
      @qrep = Person.find (self.solution.quote.rep_id)
    rescue ActiveRecord::RecordNotFound
      @qrep = Person.new(:last_name=>'none')
    end
  end

  # Provide scheduler related job state notice.
  def status_notice
    today = Date.current
    status_notice = "#{self.name}"
    case
    when today > start_on && today < finished_on
      status_notice << " is RUNNING NOW."
    when today == start_on
      status_notice << " starts TODAY."
    when today < start_on
      status_notice << " starts on #{start_on.strftime("%A, %d %B, %Y")}."
    when today > finished_on
      status_notice << " is completed."
    when start_on.nil?
      status_notice << " has no start date."
    else
      status_notice << '.'
    end
  end

  
  def display_name
    name.split(".").last || "J"
  end

  def db_display_name
    db_name = name.split(".").first << " "
    unless solution.address.nil?
      db_name << solution.address.street_address << " "
      db_name << solution.address.city << " "
      db_name << solution.address.state << " "
      db_name << solution.address.post_code << ' '
      db_name << solution.address.map_reference << ' '
    end
    db_name << name.split(".").last || "J"
  end
  

  def unused_requirement_list
    Certificate.where({:for_rig => true}) - certificates
  end
end
