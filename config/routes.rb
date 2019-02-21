Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: 'dashboard#index'

  resources :restore_wallets
  resources :task_details
  resources :create_new_task
  resources :completed_task
  resources :profile
  resources :vodeer_task_detail
  resources :rejected_task_detail
  resources :arbitary_task_detail
  resources :vodeer_task_submission

  # Health check Endpoints
  get '/_liveness', to: 'health_checks#health'
  get '/_readiness', to: 'health_checks#health'
  get '/_health', to: 'health_checks#health'
  get '/_healthz', to: 'health_checks#health'

  resources :wallets, only: %i[create show update] do
    resources :transactions, only: %i[create]
  end'

  scope 'setup_accounts' do
    get '/:page_name', to: 'setup_accounts#index', as: 'setup_accounts'
  end

  resources :tasks

  resources :user_profiles do
    collection do
      post :update_avatar
    end
  end

end
