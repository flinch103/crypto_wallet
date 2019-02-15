Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: 'dashboard#index'
  resources :restore_wallets

  # Health check Endpoints
  get '/_liveness', to: 'health_checks#health'
  get '/_readiness', to: 'health_checks#health'
  get '/_health', to: 'health_checks#health'
  get '/_healthz', to: 'health_checks#health'

  resources :wallets, only: %i[create update]

  scope 'setup_accounts' do
    get '/:page_name', to: 'setup_accounts#index', as: 'setup_accounts'
  end
end
