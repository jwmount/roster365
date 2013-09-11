#require 'debugger'

class Project < ActiveRecord::Base
  include Sluggable

  # audited, not on Rails 4 yet

  belongs_to :company

  has_many :certificates, :through => :requirements
  has_many :quotes,       :dependent => :destroy
#  has_one  :rep,          :as => :person
#  has_one  :rep
  has_many  :people

  # polymorphs
  has_many  :addresses,     :as => :addressable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :addresses
  has_many :requirements


  validates_presence_of :name
  validates_presence_of :company_id

  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  scope :bidding, where(:intend_to_bid => true)
  scope :alphabetically, order("name ASC")

  # C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     C A L L B A C K S     
  after_initialize :set_defaults
  
  # Best practice in Rails is set defaults here and not in database
  def set_defaults
    unless persisted?
      self.active ||= true 
      self.rep_id ||= nil
      self.project_start_on  ||= Time.now
    end
  end

  def address
  end

  # form of find works, see use to scope to employee Reps in projects.rb
  def XXrequirement_list
    Certificate.where({:for_company => true} | {:for_person => true}) - certificates
  end


end

