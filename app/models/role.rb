class Role < ActiveRecord::Base

  attr_accessible :user_ids
  attr_accessible :name
  
  has_and_belongs_to_many :users, :class_name => "AdminUser", :join_table => "roles_users", :association_foreign_key => "user_id"
  
  validates_presence_of :name

  audited
  
  class << self
    def by_name
      order("name ASC")
    end
  end
end
