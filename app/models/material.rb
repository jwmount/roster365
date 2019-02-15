class Material < ActiveRecord::Base

  # audited, not on Rails 4 yet

  has_many :requirements, :dependent => :destroy
  has_many :certificates, :through => :requirements
  has_many :solutions, :dependent => :destroy


=begin
	
old format for scope
  scope :name_ascending, order("name ASC")
=end

  def requirement_list
    Certificate.where(:for_equipment => true) - certificates
  end
end
