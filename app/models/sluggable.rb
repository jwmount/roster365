module Sluggable 
  
  def display_name
    name
  end


  def to_param
    "#{id}-#{display_name.parameterize}"
  end


end
