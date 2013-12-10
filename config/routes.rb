# http://pivotallabs.com/rails-4-upgrade/

Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :dispatches
  
  # Generate all routes in Admin namespace
  ActiveAdmin.routes(self)
  
  # set namespace root in active_admin.rb
  root :to => "companies#index"

  # Generate full path methods not done automatically to support bread crumbs all the way down and back up.
  # Eventually we can simplify this so that each dependent is at one level down, but before that's possible
  # how ActiveAdmin does the bread crumb navigation has to be accomodated or those paths will be invalid.
  namespace :admin do
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
  end
 
end #routes