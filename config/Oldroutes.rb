Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root :to => "application#index"

  scope module: 'admin' do

    resources :ability, :address, :admin_user, :cert, :certificate, :company, :condition, :contact_schedule,
               :docket, :engagement, :equipment, :identifier, :job, :material, :person, :project, :project_contact,
               :quote, :requirement, :role, :schedule, :solution, :solutions_tips, :tip

    resources :certificates do
      resources :certs
    end
    
    resources :companies do
      resource :address
      resources :people
      resources :identifiers
      resources :equipment
    end

    resources :companies do
      resources :projects
      member do
        patch 'project'
      end
    end

    resources :company do
      resources :project do
        resources :quote do
          resources :solution do
            resources :job
          end
        end
      end
    end

    resources :companies do
      resources :projects do
        resources :requirements
        resources :quotes do
          resources :solutions do
            resources :jobs
          end
        end
      end
    end

    resources :companies do
      resources :equipment
      member do
        patch 'equipment'
      end
    end

    
    resources :dockets do
      member do
        patch 'print'
      end
    end          


    resources :projects do
      resources :requirements
    end
    
    resources :solutions do
      member do
        patch 'costing'
      end
      member do
        patch 'approve'
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