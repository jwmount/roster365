module Sluggable 
  
  def display_name
    name
  end

  # structure how name will appear in url
  def to_param
    "#{id}-#{display_name.parameterize}"
  end


end
