class Condition < ActiveRecord::Base
  attr_accessible :approved, :change_approved_at, :change_approved_by, :indication, :name, :status, :verbiage  
  
  audited


end #condition.rb
