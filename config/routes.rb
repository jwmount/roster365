Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root :to => "application#index"


  namespace :admin do

    resources :ability
    resources :address
    resources :admin_user
    resources :cert
    resources :certificate
    resources :company
    resources :condition
    resources :contact_schedule
    resources :docket
    resources :engagement
    resources :equipment
    resources :identifier
    resources :job
    resources :material
    resources :person
    resources :project
    resources :project_contact
    resources :quote
    resources :requirement
    resources :role
    resources :schedule
    resources :solution
    resources :solutions_tips
    resources :tip

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
        patch 'print'
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
        patch 'costing'
      end
    end
    
    resources :quotes do
      member do
        patch 'print'
      end
      member do
        patch 'express'
      end
    end  
    

    resources :jobs do
      resources :schedules
    end
    
    resources :jobs do
      member do
        patch 'jobify'
      end
    end
    
    resources :schedules do
      resources :engagements do
        resources :dockets
      end
    end

    resources :engagements do
      member do
        patch 'docketify'
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