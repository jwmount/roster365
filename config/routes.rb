Roster365::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Generate all routes in Admin namespace
  ActiveAdmin.routes(self)

  root :to => "companies#index"

  resources :company do
  	resource :equipment
  end
  
end #routes