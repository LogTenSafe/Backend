Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :account, controller: 'account', only: [:edit, :update, :destroy]
  resources :users, only: [:new, :create]
  resources :backups, only: [:index, :show, :create, :destroy]

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  root to: 'backups#index'
end
