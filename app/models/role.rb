class Role < ActiveRecord::Base

  # audited, not on Rails 4 yet
  
  has_many :admin_users
  #has_and_belongs_to_many :adminUsers
  
  validates_presence_of :name
  
  # scope :alphabetically, order("name ASC")

  class << self
    def by_name
      order("name ASC")
    end
  end
end
