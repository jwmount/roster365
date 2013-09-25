#require 'debugger'

class Schedule < ActiveRecord::Base

  belongs_to :job
  has_many :engagements, :dependent => :destroy
  has_and_belongs_to_many :people

  # audited, not on Rails 4 yet
  after_initialize :set_defaults

  scope :is_active?, includes(:job).where("jobs.active = ?", true)
#  pg fails on this
#  scope :ongoing, where("DATE(day) <= DATE(NOW() + INTERVAL 3 DAY)")
  scope :by_start_on, order("day DESC")
  
  validate :day, :presence => true
  validate :validate_date
  validate :job, presence => true


  def set_defaults
    day = Date.current unless day
  end

  # Modified to work with datepicker and datetime fields --JWM
  def validate_date
    if self.day < (Date.yesterday)
      errors.add(:day, "PROBLEM:  Scheduled date cannot be in the past")
    end
  end

  attr_accessor :search

  def display_name
    name = self.job.nil? ? 'None' : self.job.display_name
    "#{self.day.to_s(:short)} - #{name}"
  end

  # collection of identifiers or numbers for a rep
  def rep_identifiers id
    person = Person.find id
    identifiers = person.identifiers.order(:rank)
  end
  
  def method_missing(name, *args, &block)
    puts "Called #{name} with #{args.inspect} and #{block}"
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
 
   def method_missing
    flash[:error] = "something's missing."
  end

end
