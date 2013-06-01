Roster365::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  root :to => "application#index"
 
  namespace :admin do

    resources :dockets
    resources :projects
    resources :addresses
    resources :identifiers
    resources :jobs      
    resources :engagements
    resources :schedules
    resources :people
    resources :quotes
    resources :solutions

    resources :companies do
      resource :address
      resources :people
      resources :identifiers
      resources :equipment
    end

    resources :companies do
      resources :projects
    end
    

    resources :dockets do
      member do
        put 'print'
      end
    end          

    resources :projects do
      resources :quotes do
        resources :solutions do
          resources :jobs
        end
      end
    end
    
    resources :solutions do
      member do
        put 'costing'
      end
    end
    
    resources :quotes do
      member do
        put 'print'
      end
      member do
        put 'express'
      end
    end  
    

    resources :jobs do
      resources :schedules
    end
    
    resources :jobs do
      member do
        put 'jobify'
      end
    end
    
    resources :schedules do
      resources :engagements do
        resources :dockets
      end
    end

    resources :engagements do
      member do
        put 'docketify'
      end
    end

    # admin_engagement_docket_path
    # need this?
    resources :engagements do
      resources :dockets
    end
    
    resources :people do
      resources :identifiers
      resources :certs
    end
    
    
  end # namespace :admin

end #routes