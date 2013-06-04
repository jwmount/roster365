class Role < ActiveRecord::Base
  
  has_and_belongs_to_many :users, :class_name => "AdminUser", :join_table => "roles_users", :association_foreign_key => "user_id"
  
  validates_presence_of :name

  # audited, not on Rails 4 yet
  
  class << self
    def by_name
      order("name ASC")
    end
  end
end
