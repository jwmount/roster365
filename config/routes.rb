Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Generate all routes in Admin namespace
  ActiveAdmin.routes(self)
  
  # set namespace root in active_admin.rb
  root :to => "companies#index"

  # Generate full path methods not done automatically to support bread crumbs all the way down and back up.
  namespace :admin do
    resources :companies do
      resources :projects do
        resources :quotes do 
          resources :solutions do #ok
            resources :jobs do
              resources :schedules do
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