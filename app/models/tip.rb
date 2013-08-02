#require 'debugger'

class Tip < ActiveRecord::Base

  belongs_to :company
  has_and_belongs_to_many :solutions

  #polymorphs
  has_many :addresses, :as => :addressable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :addresses

  has_many :identifiers, :as => :identifiable, :autosave => true, :dependent => :destroy
    accepts_nested_attributes_for :identifiers

  scope :alphabetically, order("name ASC")
  
  #Whoaa, this HACK shows off my FORTRAN background....
  # array a should be application_helper::fire_ant_risk_levels array.
  def risk_level
    i = self.fire_ant_risk_level
    a = %w[None Medium High]
    a[i]
  end

end
