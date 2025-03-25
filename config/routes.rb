Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root 'home#index'

  resources :employees do
    member do
      get :generate_payslip, defaults: { format: 'pdf' } 
      get :download_payslip  
    end
  end
  

  post '/admin/send_payslip/:id', to: 'admins#send_payslip', as: 'send_payslip_admin'
  
  get 'generate_payslip', to: 'payslips#generate_payslip'
  get 'admin/dashboard', to: 'admins#dashboard'
  get 'admin/employees/new', to: 'admins#new'
  get 'employee/dashboard', to: 'employees#dashboard'
end
