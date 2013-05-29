class Ability
  include CanCan::Ability

  # work site, enable cancan for 3.2.3
  def initialize(user)
    can :manage, :all
  end
  def Xinitialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= AdminUser.new # guest user (not logged in)

      # superadmin (have to be one to create a Contact with role of 'admin')
      # admin (works for the company, creates IDs for field teams)
      # management (can see everything, can approve certain things admins cannot, e.g. contact price approvals)
      # sales (sees anything related to accounts they have oversight for)
      # drivers (only their dockets and related, this comes later)

      if user.role? :superadmin
        can :manage, :all
      end

      if user.role? :admin
        can :manage, :all
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

      if user.role? :drivers
        # can [:read, :update], Contact, :id => user.id
        can [:create], Docket
      end

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
  end
end
