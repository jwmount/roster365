# http://pivotallabs.com/rails-4-upgrade/

Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  
  # Generate all routes in Admin namespace
  ActiveAdmin.routes(self)
  

  # Generate full path methods not done automatically to support bread crumbs all the way down and back up.
  # Eventually we can simplify this so that each dependent is at one level down, but before that's possible
  # how ActiveAdmin does the bread crumb navigation has to be accomodated or those paths will be invalid.

  namespace :admin do
  # set namespace root in active_admin.rb
  # root :to => "companies#index"

    resources :roles do
      resources :admin_users
    end

    resources :companies do
      resources :projects do
        resources :quotes do 
          resources :solutions do #ok
            resources :jobs do
              resources :schedules do
                resources :reservattions
                resources :engagements do
                  resources :dockets
                end
              end
            end
          end
        end
      end
    end

    resources :people do
      resources :dockets
    end

  end #end namespace

  namespace :api do  
    get 'names',                          to: :names
    get 'names/:name',                    to: :names
    get 'rolodex/:id',                    to: :rolodex
    get 'states',                         to: :states
    get 'states/:state',                  to: :states
    # GET /api/locations/<partial string>
    # for example:  <host>/api/locations/Bris
    get 'locations/:locality',           to: :locations
    get 'projects',                      to: :providers
    get 'project/:id',                   to: :provider
    get 'state/:state',                  to: :state
    get '/',                             to: :help
  
  end #:api namespace

 #root :to => "admin/companies#index"   works
 root :to => "admin/dashboard#index"    # better
 
end #routes