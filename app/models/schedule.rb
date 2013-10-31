#require 'debugger'

class Schedule < ActiveRecord::Base

  belongs_to :job
  has_many :engagements, :dependent => :destroy
  #has_many :equipment
  has_and_belongs_to_many :people
  #has_and_belongs_to_many :equipment

  # audited, not on Rails 4 yet
  after_initialize :set_defaults

  scope :is_active?, includes(:job).where("jobs.active = ?", true)
#  pg fails on this
#  scope :ongoing, where("DATE(day) <= DATE(NOW() + INTERVAL 3 DAY)")
  scope :by_start_on, order("day DESC")
  
  validates_presence_of :day
  validate :validate_date
  validate :job, presence => true
  validate :equipment_units_today, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than => 100}
  # Modified to work with datepicker and datetime fields --JWM

  def validate_date
    if day.nil? or day < Date.yesterday
      errors.add(:day, "PROBLEM:  Scheduled date cannot be in the past")
    end
  end

# C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
# Best practice in Rails is set defaults here and not in database
  after_initialize :set_defaults

  def set_defaults
    unless persisted?    
      day = Date.current + 1.day unless day
    end
  end


  # ?? attr_accessor :search

  def display_name
    name = self.job.nil? ? 'None' : self.job.display_name
    "#{self.day.to_s(:short)} - #{name}"
  end

  # collection of identifiers or numbers for a rep
  def rep_identifiers id
    person = Person.find id
    identifiers = person.identifiers.order(:rank)
  end
  

  # get Project Rep full name
  # Clearly this needs some work to let the user continue or to observe missing rep 
  # and step around it.  
  def prep
    begin
      @prep = Person.find (self.job.solution.quote.project.rep_id)
    rescue Exception
      @prep = Person.new(:last_name=>'none')
    end
  end

  # get Quote Rep full name (may be same as prep)
  def qrep
    begin
      @qrep = Person.find (self.job.solution.quote.rep_id)
    rescue Exception
      @qrep = Person.new(:last_name=>'none')
    end
  end

  def no_tip_assigned
    'No tip assigned.'
  end
 


end
