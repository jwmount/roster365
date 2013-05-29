#require 'debugger'

class Schedule < ActiveRecord::Base

  attr_accessible :day, :equipment_id, :equipment_units_today, :job_id

  belongs_to :job
  has_many :engagements, :dependent => :destroy
  has_and_belongs_to_many :contacts

  audited
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
    "#{self.day.to_s(:short)} - #{self.job.display_name}"
  end

  # collection of identifiers or numbers for a rep
  def rep_identifiers id
    contact = Contact.find id
    identifiers = contact.identifiers.order(:rank)
  end
  
  def method_missing(name, *args, &block)
    puts "Called #{name} with #{args.inspect} and #{block}"
  end

  # get Project Rep full name
  # Clearly this needs some work to let the user continue or to observe missing rep 
  # and step around it.  
  def prep
    begin
      @prep = Contact.find (self.job.solution.quote.project.rep_id)
    rescue ActiveRecord::RecordNotFound
      @prep = Contact.new(:last_name=>'none')
    end
  end

  # get Quote Rep full name (may be same as prep)
  def qrep
    begin
      @qrep = Contact.find (self.job.solution.quote.rep_id)
    rescue ActiveRecord::RecordNotFound
      @qrep = Contact.new(:last_name=>'none')
    end
  end

  def no_tip_assigned
    'No tip assigned.'
  end
 
end
