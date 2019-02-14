Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: 'dashboard#index'

  resources :restore_wallets
  resources :setup_accounts do
  	collection do
	  	get :setup, to: 'setup_accounts#setup'
	end
  end
end
