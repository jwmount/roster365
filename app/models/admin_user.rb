class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role
  #has_and_belongs_to_many :roles
    
  # turned off for Ninefold deployment, raises excepiton for unauthorized user
  # FIX THIS if we want to notify users on create, not required yet.  09-28-2014.
  # after_create { |admin| admin.send_reset_password_instructions }

  # Rails 5.2.2 scope
  # scope :alphabetically, order("email ASC")

  def password_required?
    new_record? ? false : super
  end


end
