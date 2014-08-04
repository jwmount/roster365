# The first argument to `can` is the action you are giving the user permission to do.
# If you pass :manage it will apply to every action. Other common actions here are
# :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on. If you pass
# :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
#
# The third argument is an optional hash of conditions to further filter the objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
# 
# Currently defined roles:
#   admin (works for the company, creates IDs for field teams)
#   demo
#   drivers (only their dockets and related, this comes later)
#   guest
#   management (can see everything, can approve certain things admins cannot, e.g. contact price approvals)
#   operations
#   sales (sees anything related to accounts they have oversight for)
#   superadmin (have to be one to create a Person with role of 'admin')
 
class Ability
  include CanCan::Ability

=begin
  nice examples
  def initialize(user)
    can :manage, :all
      #can :manage, Company
      #can :read, Project
      #can :manage, User, :id => user.id
      #can :read, ActiveAdmin::Page, :name => "Dashboard"
  end
=end
 
  # redirect loop will occur when expression leads to root or nil.
  def initialize(user)

    #can :manage, :all
    #return
    
    user ||= AdminUser.new # user (not logged in)

    case user.role.name
    
    when 'admin'
      can :manage, :all

    when 'bookeeper'
      can :read, :all
      can :manage, Docket
      
    when 'driver'
      can :read, Engagement

    when 'management'
      can :read, :all
      can :update, Solution
    
    when 'operations'
      can :read, :all
      can :manage, [Job, Schedule, Engagement]
    
    when 'sales'
      can :read, :all 
      can :manage, [Company, Project, Quote, Solution]
    
    when 'superadmin'
      can :manage, :all
    
    # we do not allow other values, we do allow login  
    # actually want to return to login
    # guest
    else
      can :read, :all
    end  
=begin
    if user.role.name == 'admin'
      can :manage, :all
    end

    if user.role.name == 'bookeeping'
      can :manage, Docket
      can :read, :all
    end

    if user.role.name == 'management'
      can :read, :all
      can :update, Solution
    end

    if user.role.name == 'operations'
      can :read, :all
      can :manage, [Job, Schedule, Engagement]
    end

    if user.role.name == 'sales'
      can :read, :all 
      can :manage, [Company, Project, Quote, Solution]
    end

    if user.role.name == 'superadmin'
      can :manage, :all
    end
    
=begin
      if user.role? :superadmin
        can :manage, :all
      end

      if user.role? :admin
        #can :manage, :all
        can :read, :all
      end

      if user.role? :management
        # can :manage, :all
        can :update, Quote, :id => 5
      end

      if user.role? :sales
          # can :manage, Account do |account|
          #   account.try(:owner) == user
          # end
      end

      if user.role? :driver
        # can [:read, :update], Person, :id => user.id
        can [:create], Docket
      end
=end
  end
end
