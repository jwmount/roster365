class Material < ActiveRecord::Base

  # audited, not on Rails 4 yet

  has_many :requirements
  has_many :certificates, :through => :requirements
  has_many :solutions


  scope :name_ascending, order("name ASC")

  def requirement_list
    Certificate.where(:for_equipment => true) - certificates
  end
end
