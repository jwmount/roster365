#require 'debugger'

class Tip < ActiveRecord::Base

  belongs_to :company
  has_and_belongs_to_many :solutions

  #polymorphs
  has_many  :addresses, 
            :as => :addressable, 
            :autosave => true, 
            :dependent => :destroy
    accepts_nested_attributes_for :addresses

  has_many :identifiers, :as => :identifiable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :identifiers

  has_many :certs, 
           :as => :certifiable, 
           :autosave => true, 
           :dependent => :destroy
    accepts_nested_attributes_for :certs


  # scope :alphabetically, order("name ASC")
  
# D E F A U L T S

  after_initialize :defaults

  def defaults
     unless persisted?
       self.fire_ant_risk_level ||= 'None'
    end
  end  
 
  # UNUSED for a moment.  Use to create select drop down for tips
  def fire_ant_risk_levels
    [
      ['None', 0],
      ['Medium', 1],
      ['High', 2]
    ]
  end
 
  def fire_ant_risk_level_name
    fire_ant_risk_levels[self.fire_ant_risk_level][0]
  end

end
